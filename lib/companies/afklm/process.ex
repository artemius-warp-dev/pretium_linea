defimpl PretiumLinea.Process, for: PretiumLinea.AFKLM do
  def receive_data(_company, params) do
    stream = PretiumLinea.AFKLM.Server.get(params)
    {:ok, stream}
  end
end
