defmodule NervesDht do
  import Supervisor.Spec

  @moduledoc ~S"""
  Read DHT sensor (Digital Humidity and Temparature)
  Example usage:
  ```
  iex> {:ok, dht} = NervesDht.start_link(22, 2)
  :ok
  iex> {:ok, humidity, temperature} = NervesDht.call(dht)
  {:ok, 41.3, 27.22}
  ```
  You can use `add_handler` too listen event of sensor too.
  For example:
  ```
  iex> {:ok, dht} = NervesDht.start_link(22, 2)
  :ok
  iex> defmodule MyGenServer do
         use GenServer

         def start_link(state, opts \\ []) do
           GenServer.start_link(__MODULE__, state, opts)
         end

         def handle_cast({:ok, h, t}, state) do
           IO.puts("Listen event on MyGenServer")
           IO.puts("Temperature: #{t} Humidity: #{h})\n")
           {:noreply, state}
         end
       end
  :ok
  iex> NervesDht.add_handler(dht, MyGenServer)
  :ok
  Listen event on MyGenServer
  (Temperature: 41.3 Humidity: 27.20)

  Listen event on MyGenServer
  (Temperature: 41.2 Humidity: 27.25)
  ```
  """

  def start_link(sensor, pin) do
    child = worker(GenServer, [], restart: :temporary)
    {:ok, pid} = Supervisor.start_link([child], strategy: :simple_one_for_one)
    NervesDht.Driver.start_link(pid, sensor, pin)
    {:ok, pid}
  end

  def stop(sup) do
    for {_, pid, _, _} <- Supervisor.which_children(sup) do
      GenServer.stop(pid, :normal)
    end
    Supervisor.stop(sup)
  end

  def add_handler(sup, handler) do
    sup |> Supervisor.start_child([handler, []])
  end

  def call(_sup) do
    #    GenServer.call()
    {:error, "TODO"}
  end

  def notify(sup, state) do
    for {_, pid, _, _} <- Supervisor.which_children(sup) do
      GenServer.cast(pid, state)
    end
    :ok
  end

end
