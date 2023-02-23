defmodule PretiumLinea.MockData do
  # TODO mock response. String to stream
  def mock_afklm_response() do
    priv = :code.priv_dir(:pretium_linea)
    filename = "afklm.xml"
    File.stream!("#{priv}/#{filename}")
  end

  def mock_ba_response() do
    priv = :code.priv_dir(:pretium_linea)
    filename = "ba.xml"
    File.stream!("#{priv}/#{filename}")
  end
end
