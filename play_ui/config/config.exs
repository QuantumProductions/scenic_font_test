use Mix.Config

# Configure the main viewport for the Scenic application
config :play, :viewport, %{
  name: :main_viewport,
  size: {500, 500},
  default_scene: {Play.Scene.GameOver, Play.Scene.Asteroids},
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      name: :glfw,
      opts: [resizeable: false, title: "play"]
    }
  ]
}

case Mix.env() do
  :dev ->
    config :exsync,
      reload_timeout: 75,
      reload_callback: {GenServer, :call, [ScenicLiveReload, :reload_current_scene]}

  _ -> nil
end
