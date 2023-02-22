defimpl PretiumLinea.Process, for: PretiumLinea.BA  do
  def receive_data(_company, params) do
    stream = PretiumLinea.BA.Server.get(params)
    {:ok, stream}
  end
end
