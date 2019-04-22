defmodule Play.Scene.GameOver do
  use Scenic.Scene
  import Scenic.Primitives
  alias Scenic.Graph

  @font_folder :code.priv_dir(:play) |> Path.join("/static/fonts")
  @custom_font_hash "UYe2ryfLUpczug9LKyrTxPYGSYTimnPHzpSMbC6UF0M"
  @custom_metrics_path :code.priv_dir(:scenic_example)
           |> Path.join("/static/fonts/Courier New.ttf.metrics")
  @custom_metrics_hash Scenic.Cache.Support.Hash.file!(@custom_metrics_path, :sha)

  @initial_graph Graph.build()
                 # Rectangle used for capturing input for the scene
                 |> rect({Play.Utils.screen_width(), Play.Utils.screen_height()})
                 |> text("",
                   id: :welcome,
                   t: {Play.Utils.screen_width() / 2, Play.Utils.screen_height() * 0.05},
                   fill: :white,
                   font: :roboto_mono,
                   text_align: :center
                 )

  defmodule State do
    @moduledoc false
    defstruct [:viewport]
  end

  @impl Scenic.Scene
  def init(score, scenic_opts) do
    Cache.Static.Font.load(@font_folder, @custom_font_hash)
    Cache.Static.FontMetrics.load(@custom_metrics_path, @custom_metrics_hash)

    state = %State{viewport: scenic_opts[:viewport]}

    graph = show_welcome()

    {:ok, state, push: graph}
  end

  @impl Scenic.Scene
  def handle_input({:cursor_button, {_, :press, _, _}}, _context, state) do
    restart_game(state)
    {:noreply, state}
  end

  def handle_input({:key, {key, _, _}}, _context, state) do
    case String.to_charlist(key) do
      [char] when char in ?A..?Z or key in [" "] ->
        restart_game(state)

      _ ->
        nil
    end

    {:noreply, state}
  end

  def handle_input(_, _, state), do: {:noreply, state}

  defp restart_game(%State{viewport: vp}) do
    Scenic.ViewPort.set_root(vp, {Play.Scene.Splash, Play.Scene.Asteroids})
  end

  defp show_welcome do
    message = "Hello World"

    @initial_graph
    |> Graph.modify(:welcome, &Scenic.Primitives.text(&1, message))
  end

  defp show_score(score) do
    message = "Your score was: #{score}"

    @initial_graph
    |> Graph.modify(:score, &Scenic.Primitives.text(&1, message))
  end
end
