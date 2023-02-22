defprotocol PretiumLinea.Process do
  def receive_data(company, params)
end
