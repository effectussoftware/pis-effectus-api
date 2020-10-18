# frozen_string_literal: true

json.extract! communication,
              :id,
              :title,
              :text,
              :published,
              :recurrent_on,
              :created_at,
              :updated_at

json.image communication.image_url
