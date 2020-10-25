# frozen_string_literal: true

json.extract! communication,
              :id,
              :title,
              :text

json.image communication.image_url if communication.image.attached?
