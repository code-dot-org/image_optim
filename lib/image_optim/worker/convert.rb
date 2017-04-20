require 'image_optim/worker'
require 'image_optim/option_helpers'

class ImageOptim
  class Worker
    # Use ImageMagick to normalize color to sRGB profile.
    class Convert < Worker
      # Run early
      def run_order
        -9
      end

      def image_formats
        [:jpeg, :png]
      end

      def optimize(src, dst)
        args = %W[
          #{src}
          -profile #{File.join(__dir__, 'sRGB.icc')}
          #{dst}
        ]
        execute(:convert, *args)
      end
    end
  end
end
