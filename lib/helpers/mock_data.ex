defmodule PretiumLinea.MockData do
  @moduledoc false

  # TODO mock response. String to stream
  def mock_afkl_response() do
    priv = :code.priv_dir(:pretium_linea)
    filename = "afkl.xml"
    File.stream!("#{priv}/#{filename}")
  end

  def mock_ba_response() do
    priv = :code.priv_dir(:pretium_linea)
    filename = "ba.xml"
    File.stream!("#{priv}/#{filename}")
  end
end
