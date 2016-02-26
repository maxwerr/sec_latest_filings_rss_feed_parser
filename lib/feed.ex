defmodule SecLatestFilingsRssFeedParser.Feed do
  @moduledoc """
  This module handles the parsing and creation of a feed
  map. A feed in the SEC's Latest Filings RSS Feed is defined
  by the content between opening <feed> and closing </feed>
  tags, including metadata and multiple entries
  """

  alias SecLatestFilingsRssFeedParser.Helpers

  defstruct [:entry]

  @doc """
  SecLatestFilingsRssFeedParser.parse/1 returns a map of
  a feed with its updated date and many entries.
  """

  def parse(xml) do
    %{
      updated: parse_updated(xml),
      entries: parse_feed(xml)
    }
  end

  defp parse_feed(xml) do
    Floki.find(xml, "entry")
    |> Enum.map(fn entry -> SecLatestFilingsRssFeedParser.Entry.parse(Floki.raw_html(entry)) end)
  end

  defp parse_updated(feed) do
    feed
    |> Floki.find("updated")
    |> hd
    |> Helpers.extract_last_item
  end
end
