# frozen_string_literal: true

# Скопировано отсюда: https://gist.github.com/maxivak/3924976
module ImageCropper
  GRAVITY_TYPES = %i[north_west north north_east east south_east south south_west west center].freeze

  class << self
    def resize_with_crop(img, width, height, **options)
      gravity = options[:gravity] || :center

      w_original = img[:width].to_f
      h_original = img[:height].to_f

      if w_original * height < h_original * width
        op_resize = "#{width.to_i}x"
        w_result  = width
        h_result  = (h_original * width / w_original)
      else
        op_resize = "x#{height.to_i}"
        w_result  = (w_original * height / h_original)
        h_result  = height
      end

      w_offset, h_offset = crop_offsets_by_gravity(gravity, [w_result, h_result], [width, height])

      img.combine_options do |i|
        i.resize(op_resize)
        i.gravity(gravity)
        i.crop "#{width.to_i}x#{height.to_i}+#{w_offset}+#{h_offset}!"
      end

      img
    end

    private

    def crop_offsets_by_gravity(gravity, original_dimensions, cropped_dimensions)
      unless GRAVITY_TYPES.include?(gravity.to_sym)
        raise ArgumentError, "Gravity must be one of #{GRAVITY_TYPES.inspect}"
      end

      unless original_dimensions.is_a?(Enumerable) && original_dimensions.size == 2
        raise ArgumentError, 'Original dimensions must be supplied as a [ width, height ] array'
      end

      unless cropped_dimensions.is_a?(Enumerable) && cropped_dimensions.size == 2
        raise ArgumentError, 'Cropped dimensions must be supplied as a [ width, height ] array'
      end

      original_width, original_height = original_dimensions
      cropped_width, cropped_height   = cropped_dimensions

      vertical_offset = case gravity
                        when :north_west, :north, :north_east
                          0
                        when :center, :east, :west
                          [((original_height - cropped_height) / 2.0).to_i, 0].min
                        when :south_west, :south, :south_east
                          (original_height - cropped_height).to_i
                        end

      horizontal_offset = case gravity
                          when :north_west, :west, :south_west
                            0
                          when :center, :north, :south
                            [((original_width - cropped_width) / 2.0).to_i, 0].min
                          when :north_east, :east, :south_east
                            (original_width - cropped_width).to_i
                          end

      [horizontal_offset, vertical_offset]
    end
  end
end
