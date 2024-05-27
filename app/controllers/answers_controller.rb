require 'net/http'
require 'uri'

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
    uri = URI.parse(url)

    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    
    rescue URI::InvalidURIError
      return false
  end

  def image_url?(url) 
    ext = url.slice(url.length, 3)

    images = ["jpg", "png", "gif"]
    images.each do |image|
      if image == ext
        return true
      end  
    end

    return false

    rescue
      return false
  end
end