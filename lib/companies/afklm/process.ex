defimpl PretiumLinea.Process, for: PretiumLinea.AFKL do
  def receive_data(_company, params) do
    stream = PretiumLinea.AFKL.Server.get(params)
    {:ok, stream}
  end
end
