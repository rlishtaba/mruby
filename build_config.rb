MRuby::Build.new do |conf|
  # load specific toolchain settings

  # Gets set by the VS command prompts.
  if ENV['VisualStudioVersion'] || ENV['VSINSTALLDIR']
    toolchain :visualcpp
  else
    toolchain :gcc
  end

  enable_debug

  # Use mrbgems
  # conf.gem 'examples/mrbgems/ruby_extension_example'
  # conf.gem 'examples/mrbgems/c_extension_example' do |g|
  #   g.cc.flags << '-g' # append cflags in this gem
  # end
  # conf.gem 'examples/mrbgems/c_and_ruby_extension_example'
  # conf.gem :github => 'masuidrive/mrbgems-example', :checksum_hash => '76518e8aecd131d047378448ac8055fa29d974a9'
  # conf.gem :git => 'git@github.com:masuidrive/mrbgems-example.git', :branch => 'master', :options => '-v'

  # include the default GEMs
  conf.gembox 'default'

  # C compiler settings
  # conf.cc do |cc|
  #   cc.command = ENV['CC'] || 'gcc'
  #   cc.flags = [ENV['CFLAGS'] || %w()]
  #   cc.include_paths = ["#{root}/include"]
  #   cc.defines = %w(DISABLE_GEMS)
  #   cc.option_include_path = '-I%s'
  #   cc.option_define = '-D%s'
  #   cc.compile_options = "%{flags} -MMD -o %{outfile} -c %{infile}"
  # end

  # mrbc settings
  # conf.mrbc do |mrbc|
  #   mrbc.compile_options = "-g -B%{funcname} -o-" # The -g option is required for line numbers
  # end

  # Linker settings
  # conf.linker do |linker|
  #   linker.command = ENV['LD'] || 'gcc'
  #   linker.flags = [ENV['LDFLAGS'] || []]
  #   linker.flags_before_libraries = []
  #   linker.libraries = %w()
  #   linker.flags_after_libraries = []
  #   linker.library_paths = []
  #   linker.option_library = '-l%s'
  #   linker.option_library_path = '-L%s'
  #   linker.link_options = "%{flags} -o %{outfile} %{objs} %{libs}"
  # end

  # Archiver settings
  # conf.archiver do |archiver|
  #   archiver.command = ENV['AR'] || 'ar'
  #   archiver.archive_options = 'rs %{outfile} %{objs}'
  # end

  # Parser generator settings
  # conf.yacc do |yacc|
  #   yacc.command = ENV['YACC'] || 'bison'
  #   yacc.compile_options = '-o %{outfile} %{infile}'
  # end

  # gperf settings
  # conf.gperf do |gperf|
  #   gperf.command = 'gperf'
  #   gperf.compile_options = '-L ANSI-C -C -p -j1 -i 1 -g -o -t -N mrb_reserved_word -k"1,3,$" %{infile} > %{outfile}'
  # end

  # file extensions
  # conf.exts do |exts|
  #   exts.object = '.o'
  #   exts.executable = '' # '.exe' if Windows
  #   exts.library = '.a'
  # end

  # file separetor
  # conf.file_separator = '/'

  # bintest
  # conf.enable_bintest
end

# MRuby::Build.new('host-debug') do |conf|
#   # load specific toolchain settings
#
#   # Gets set by the VS command prompts.
#   if ENV['VisualStudioVersion'] || ENV['VSINSTALLDIR']
#     toolchain :visualcpp
#   else
#     toolchain :gcc
#   end
#
#   enable_debug
#
#   # include the default GEMs
#   conf.gembox 'default'
#
#   # C compiler settings
#   conf.cc.defines = %w(ENABLE_DEBUG)
#
#   # Generate mruby debugger command (require mruby-eval)
#   conf.gem :core => "mruby-bin-debugger"
#
#   # bintest
#   # conf.enable_bintest
# end

# Define cross build settings
# MRuby::CrossBuild.new('32bit') do |conf|
#   toolchain :gcc
#
#   conf.cc.flags << "-m32"
#   conf.linker.flags << "-m32"
#
#   conf.build_mrbtest_lib_only
#
#   conf.gem 'examples/mrbgems/c_and_ruby_extension_example'
#
#   conf.test_runner.command = 'env'
#
# end


MRuby::CrossBuild.new("telium") do |conf|
  toolchain :gcc

  BIN_PATH = "C:/Tools/arm-elf-gcc-4.7.3-r1/bin"

  # SAM_PATH = "#{ARDUINO_PATH}/hardware/arduino/sam"
  # TARGET_PATH = "#{SAM_PATH}/variants/arduino_due_x"

  conf.cc do |cc|
    cc.command = "#{BIN_PATH}/arm-elf-gcc"
    cc.include_paths << []
    cc.flags = %w(
    -Wall
    -Wno-deprecated-declarations
    -Wno-write-strings
    -Wno-attributes
    -std=gnu++0x
    -D_GLIBCXX_USE_C99
    -D_GLIBCXX_USE_C99_DYNAMIC
    )
    cc.compile_options = "%{flags} -o %{outfile} -c %{infile}"

    #configuration for low memory environment
    # cc.defines << %w(MRB_HEAP_PAGE_SIZE=64)
    # cc.defines << %w(MRB_USE_IV_SEGLIST)
    # cc.defines << %w(KHASH_DEFAULT_SIZE=8)
    # cc.defines << %w(MRB_STR_BUF_MIN_SIZE=20)
    # cc.defines << %w(MRB_GC_STRESS)
    #cc.defines << %w(DISABLE_STDIO) #if you dont need stdio.
    #cc.defines << %w(POOL_PAGE_SIZE=1000) #effective only for use with mruby-eval
  end

  conf.cxx do |cxx|
    cxx.command = "#{BIN_PATH}/arm-elf-g++"
    cxx.include_paths = conf.cc.include_paths.dup
    cxx.flags = conf.cc.flags.dup
    cxx.flags << conf.cc.flags.dup + %w( -fno-rtti -fno-exceptions)
    cxx.defines = conf.cc.defines.dup
    cxx.compile_options = conf.cc.compile_options.dup
  end

  conf.archiver do |archiver|
    archiver.command = "#{BIN_PATH}/arm-elf-ar"
    archiver.archive_options = 'rcs %{outfile} %{objs}'
  end

  #no executables
  conf.bins = []

  #do not build executable test
  # conf.build_mrbtest_lib_only

  #disable C++ exception
  conf.disable_cxx_exception

  #gems from core
  # conf.gem :core => "mruby-print"
  # conf.gem :core => "mruby-math"
  # conf.gem :core => "mruby-enum-ext"

  #light-weight regular expression
  # conf.gem :github => "masamitsu-murase/mruby-hs-regexp", :branch => "master"

  #Arduino API
  #conf.gem :github =>"kyab/mruby-arduino", :branch => "master"

end