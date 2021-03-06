defmodule Fw.MixProject do
  use Mix.Project

  @all_targets [:rpi3]

  def project do
    [
      app: :fw,
      version: "0.1.0",
      elixir: "~> 1.6",
      archives: [nerves_bootstrap: "~> 1.0"],
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.target() != :host,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Fw.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves, "~> 1.3", runtime: false, targets: @all_targets},
      {:nerves_firmware_ssh, ">= 0.0.0", targets: @all_targets},
      {:shoehorn, "~> 0.4"},
      {:ring_logger, "~> 0.4"},
      {:toolshed, "~> 0.2"},

      {:dialyxir, "1.0.0-rc.4", only: :dev, runtime: false},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},

      {:play, path: "../play"},

      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_init_gadget, "~> 0.4", targets: @all_targets},
      {:scenic_driver_nerves_rpi, "0.10.0", targets: @all_targets},
      {:scenic_driver_nerves_touch, "0.10.0", targets: @all_targets},
      {:nerves_system_rpi3, "~> 1.0", runtime: false, targets: :rpi3}
    ]
  end
end
