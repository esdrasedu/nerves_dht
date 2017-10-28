defmodule NervesDht do

  @moduledoc ~S"""
  Read DHT sensor (Digital Humidity and Temparature)
  Example usage:
  ```
  iex> defmodule MyGenServer do
         use NervesDht
       end
  :ok
  iex> {:ok, dht} = MyGenServer.start_link({2, 22})
  :ok
  iex> {:ok, humidity, temperature} = MyGenServer.info(dht)
  {:ok, 41.3, 27.22}
  ```
  You can use `listen` too listen event of sensor too.
  For example:
  ```
  iex> defmodule MyGenServer do
         use NervesDht

         def listen({:ok, p, s, h, t}) do
           IO.puts("Listen event on MyGenServer")
           IO.puts("Pin: #{p}, Sensor: #{s}\n")
           IO.puts("Temperature: #{t}, Humidity: #{h})\n")
         end
       end
  :ok
  iex> {:ok, dht} = MyGenServer.start_link({2, 22})
  :ok
  Listen event on MyGenServer
  Pin: 2, Sensor: 22
  (Temperature: 41.3, Humidity: 27.20)

  Listen event on MyGenServer
  Pin: 2, Sensor: 22
  (Temperature: 41.2, Humidity: 27.25)
  ```
  """

  defmacro __using__(_opts) do
    quote do

      def start_link({pin, sensor}, options \\ []) do
        GenServer.start_link(__MODULE__, [{pin, sensor}], options)
      end

      def init([{pin, sensor}]) do
        Port.open({:spawn, "#{path()} #{pin} #{sensor}"}, [:binary, packet: 2])
        {:ok, {:ok, pin, sensor, nil, nil}}
      end

      def handle_info({_port, {:data, data}}, _state) do
        states = :erlang.binary_to_term(data)
        __MODULE__.listen(states)
        {:noreply, states}
      end

      def handle_call(:info, _from, state),
        do: {:reply, state, state}

      defp path, do: "#{:code.priv_dir(:nerves_dht)}/nerves_dht"

      def info(pid) do
        {:ok, _pin, _sensor, hum, tem} = GenServer.call(pid, :info)
        {:ok, hum, tem}
      end

      def listen(states), do: states
      defoverridable [listen: 1]

    end
  end

end
