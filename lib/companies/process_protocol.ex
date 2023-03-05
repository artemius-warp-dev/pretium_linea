defprotocol PretiumLinea.Process do
  @moduledoc """
  The protocol for processing offers
  """

  use PretiumLinea.Types

  @doc """
  Receiving data from company with parameters
  """
  @spec receive_data(company, params) :: {:ok, term} | {:error, atom}
  def receive_data(company, params)
end
