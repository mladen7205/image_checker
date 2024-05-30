require "uri"
require "down"
require "mini_mime"

class AnswersController < ApplicationController
  def answer
    url = params[:url]

    if url.blank?
      render json: {error: "Missing URL parameter"}, status: :bad_request

      return
    end

    if not valid_url?(url)
      render json: {error: "Invalid URL format"}, status: :bad_request

      return
    end

    if image_url?(url)
      render json: {message: "This is an image"}
    else
      render json: {message: "This is not an image"}
    end
  end

  private

  def valid_url?(url)
    uri = URI(url)

    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    
    rescue URI::InvalidURIError
      return false
  end

  def image_url?(url)
    str = url.to_s
    str[6] = "//"

    tempfile = Down.download(str)
    type = MiniMime.lookup_by_filename(tempfile.original_filename).content_type
    tempfile.close

    type.start_with?("image")
  rescue
    false
  end
end