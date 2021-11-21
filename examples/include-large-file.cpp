#include <iostream>
#include <numeric>
#include <string>
#include <vector>

#include <assert.h>

// CHAR_WIDTH defined as CMake variable
#if CHAR_WIDTH == 2
using string                = std::wstring;
static std::wostream & cout = std::wcout;
#  define STR( x ) L##x
#else
using string               = std::string;
static std::ostream & cout = std::cout;
#  define STR( x ) x
#endif

int
main( int, char ** )
{
  // Following techniques based on:
  // https://stackoverflow.com/questions/410980/include-a-text-file-in-a-c-program-as-a-char
  // https://stackoverflow.com/questions/2481998/how-do-i-include-extremely-long-literals-in-c-source
  static std::vector<string> const chunks = {
#include "generated/LargeFile.h"
  };

  static string contents =
      std::accumulate( chunks.begin(), chunks.end(), string() );

  auto contentsLineCount  = chunks.size();
  auto contentsSize       = contents.size();
  auto largeFileLineCount = LARGEFILE_LINECOUNT;
  auto largeFileSize      = LARGEFILE_SIZE;
  cout << STR( "Contents size: " ) << contentsSize << '\n';
  cout << STR( "Original size: " ) << largeFileSize << '\n';
  cout << STR( "Contents lines: " ) << contentsLineCount << '\n';
  cout << STR( "Original lines: " ) << largeFileLineCount << '\n';

  assert( contentsLineCount == largeFileLineCount );
  assert( contentsSize == largeFileSize );
}
