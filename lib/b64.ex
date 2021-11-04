defmodule B64 do
  @moduledoc """
  Documentation for `B64`.
  """

  # Exit codes
  @ok 0
  @unknown_option 1
  @decode_error 2
  @read_stdin_error 3
  @too_many_args 4
  @too_many_options 5

  
  @usage """
  Usage: b64 [--encode|--decode] [STRING]

    A command-line tool for working with base-64 encoded strings.

    STRING - If encoding, STRING is a unicode, ASCII, or binary string.
             If decoding, STRING is a base-64 encoded string.
             Optionally, STRING can be piped from STDIN.

  Options:
    --decode       Decode a base-64 encoded string to a binary string.
    -d             Alias for --decode.
    --encode       Encode a unicode, ASCII, or binary string to base-64.
    -e             Alias for --encode.
    --help         Prints this message.
    --urldecode    Decode a base-64 encoded string containing URL safe 
                   characters.
    --urlencode    Encode a base-64 string using URL safe characters.

  Examples:
    > b64 --encode hello
    aGVsbG8=

    > b64 --decode aGVsbG8=
    hello

    > echo 'hello' | b64 --encode
    aGVsbG8=
  """

  defp print_usage() do
    IO.puts(@usage)
    System.halt(@ok)
  end

  @doc """
  Parse command-line arguments and attempt to perform the selected operation.
  """
  def main(args)

  def main(args) do
    options = [
      decode: :boolean,
      encode: :boolean,
      help: :boolean,
      urldecode: :boolean,
      urlencode: :boolean
    ]

    aliases = [
      e: :encode,
      d: :decode
    ]

    {parsed, payload, unused} = OptionParser.parse(args, strict: options, aliases: aliases)

    # Error if unrecognized options are provided.
    if unused != [] do
      IO.puts(:stderr, "Argument #{elem(hd(unused), 0)} is not recognized as a valid option.")
      System.halt(@unknown_option)
    end

    if Keyword.keys(parsed) == [:help], do: print_usage()

    # Tee stdin and payload from argv.
    input = case payload do
      # payload from argv
      [data] -> data
      # stdin
      [] -> case IO.read(:stdio, :all) do
        {:error, reason} ->
          IO.puts(:stderr, "Error: #{reason}")
          System.halt(@read_stdin_error)
        # Read from stdin, encode as string and remove trailing \n.
        data -> IO.chardata_to_string(data) |> String.slice(0..-2)
      end
      _ -> 
        IO.puts(:stderr, "Error: Too many arguments provided.")
        System.halt(@too_many_args)
    end

    result = case Keyword.keys(parsed) do
      [:decode] -> Base.decode64(input, ignore: :whitespace, padding: true)
      [:encode] -> Base.encode64(input, padding: true)
      [:urldecode] -> Base.url_decode64(input, ignore: :whitespace, padding: true)
      [:urlencode] -> Base.url_encode64(input, padding: true)
      _ -> 
        IO.puts(:stderr, "Error: Too many options provided.")
        System.halt(@too_many_options)
    end

    case result do
      {:ok, res} -> IO.puts("#{res}")
      :error -> 
        IO.puts("Error decoding")
        System.halt(@decode_error)
      _ -> IO.puts("#{result}")
    end
  end
end
