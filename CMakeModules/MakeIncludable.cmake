# @brief Prepares a specified input_file to be usable for inclusion in a C/C++
# program.
# @param input_file Name of the file to read from.
# @param output_file Name of the file to write to.
# @param delim Character string to use as delimiters for the raw character
#              string. Up to 16 non-whitespace characters can be specified.
# @param prefix The characters to place before the raw string to denote type,
#               e.g. "u8","u", "U", or "L".
#               See: https://www.stroustrup.com/C++11FAQ.html#raw-strings
# @param line_count_out Variable to store the number of strings being created.
# @param size_out Variable to store the size of the file read.
#
# Based and expanded on:
# https://stackoverflow.com/questions/410980/include-a-text-file-in-a-c-program-as-a-char
#
# Addiionally, this implements breaking up the string into chunks that can be
# stored in an array/vector. This is necessary for exceedingly large files. The
# maximum chunk size is defined by the variable: MAX_STRING_INCLUDE_SIZE
#
# Some compilers may have limits on the maximum character array length (i.e. on
# Visual studio, it is 16380, see Compiler Error C2026), and a maximum total
# string size (i.e. on Visual Studio this is 65536). This function enables you
# to bypass these limits and break it up into an array of smaller character
# sequences, which can then be reassembled in code.
#
# For an example on how to handle large files (that exceed the compiler limits),
# see:
# https://stackoverflow.com/questions/2481998/how-do-i-include-extremely-long-literals-in-c-source
#
# See the include-large-file.cpp example in this repository for runnable
# example.
#
# @note: This just enables you to include large files as strings in your code.
# Whether or not you _should_ do this is another question.

set( MAX_STRING_INCLUDE_SIZE 8000
    CACHE STRING
    "Maximum size for includable strings. Reduce if get \"string too big\" error."
)

function( make_includable input_file output_file delim prefix line_count_out size_out )

    file( READ ${input_file} content )
    set( out_content "" )
    set( line_count 0 )

    string( LENGTH "${content}" content_size )
    set( ${size_out} ${content_size} PARENT_SCOPE )

    if ( ${content_size} LESS ${MAX_STRING_INCLUDE_SIZE} )
      set( content "${prefix}R\"${delim}(\n${content})${delim}\"" )
      set( out_content "${content}")
      set( line_count 1 )
    else()
      message( STATUS
          "make_includable(): Input file: ${input_file} with size: "
          "${content_size} is larger than the maximum specified size: "
          "${MAX_STRING_INCLUDE_SIZE}, splitting it up..."
      )

      set( start_pos 0 )
      while ( start_pos LESS content_size )

        set( chunk_size ${MAX_STRING_INCLUDE_SIZE} )
        MATH( EXPR end_pos ${start_pos}+${chunk_size} )
        if ( end_pos GREATER content_size )
          set( chunk_size -1 )
        endif()

        string( SUBSTRING "${content}" ${start_pos} ${chunk_size} chunk )

        set( out_content "${out_content}\n${prefix}R\"${delim}(${chunk})${delim}\",")
        math( EXPR start_pos ${start_pos}+${MAX_STRING_INCLUDE_SIZE} )

        MATH( EXPR line_count ${line_count}+1 )
      endwhile()

    endif()

    message( DEBUG "Writing ${count} lines to includable file to: ${output_file}")
    file( WRITE ${output_file} "${out_content}" )

    set( ${line_count_out} ${line_count} PARENT_SCOPE )

endfunction( make_includable )
