require "uri"
require "down"
require "cgi"

class AnswersController < ApplicationController
  def answer
    url = params[:url]
    query_string = request.query_string

    if url.blank?
      render json: {error: "Missing URL parameter"}, status: :bad_request

      return
    end

    url = CGI.unescape(url)

    if not valid_url?(url)
      render json: {error: "Invalid URL format"}, status: :bad_request

      return
    end

    if not query_string.blank?
      url = url + "?#{query_string}"
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
    url[url.index("/")] = "//"

    tempfile = Down.download(url)
    type = tempfile.content_type
    tempfile.close

    type.start_with?("image")

  rescue
    false
  end
end