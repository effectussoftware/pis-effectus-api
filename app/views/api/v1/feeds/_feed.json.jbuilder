# frozen_string_literal: true

json.extract! feed,
              :id,
              :title,
              :text,
              :type,
              :address,
              :start_time,
              :end_time,
              :updated_at,
              :image,
              :changed_last_seen,
              :cancelled,
              :attend,
              :confirmation
