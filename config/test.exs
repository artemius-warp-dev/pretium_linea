import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pretium_linea, PretiumLineaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "YBWy0p3MdyUCK1T0HcOO2vNn0TNKO6PSfuhqLKoDvqGW6xLdEIYYt4SkIeaUPAPG",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
