# Package

version       = "0.2.0"
author        = "Max Levine"
description   = "Split bed by bai estimated read counts command-line tool"
license       = "MIT"
srcDir        = "src"
bin           = @["split_bed_by_index"]


# Dependencies

requires "nim >= 0.19.0", "hts", "docopt"
