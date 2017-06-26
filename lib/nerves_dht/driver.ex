defmodule NervesDht.Driver do
  use GenServer

  def start_link(supervisor, sensor, pin) do
    GenServer.start_link(__MODULE__, [supervisor, sensor, pin])
  end

  def init([supervisor, sensor, pin]) do
    Port.open({:spawn, "#{path()} #{sensor} #{pin}"}, [:binary, packet: 2])
    {:ok, {:ok, supervisor, sensor, pin, nil, nil}}
  end

  def handle_info({_port, {:data, data}}, {:ok, supervisor, _s, _p, _h, _t}) do
    {:ok, sensor, pin, hum, tem} = :erlang.binary_to_term(data)
    NervesDht.notify(supervisor, {:ok, hum, tem})
    {:noreply, {:ok, supervisor, sensor, pin, hum, tem}}
  end

  def handle_call(:info, _from, state) do
    {:reply, state, state}
  end

  defp path, do: "#{:code.priv_dir(:nerves_dht)}/nerves_dht"

  def info(pid) do
    {:ok, _supervisor, _sensor, _pin, hum, tem} = GenServer.call(pid, :info)
    {:ok, hum, tem}
  end

end
