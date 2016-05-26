extract-audio.cmd
=================

    Extract (and, if necessary, convert) audio streams to an appropriate audio
    file format in your Music\ folder

Usage
-----

    extract-audio.cmd <inpath>

        <inpath>    Path to input file. Required. Can be drag-and-dropped in
                    Windows explorer.

Description
-----------

    If <inpath> is in the output directory, special "in-place" behaviour takes
    effect where "original" versions of all processed files are maintained under
    double-underscore-prefixed names.  Attempts to reprocess files are
    transparently reprocessed from the "original" versions.  Once the user deems
    the output files satisfactory, the "originals" can be deleted.

Prerequisites
-------------

    ffmpeg

Config File
-----------

    %userprofile%\_extract-audio-config.cmd

        <outdir>    Full path to directory to place output files in (no
                    trailing backslash)

                    Default:
                    %userprofile%\Music

                    Example:
                    set "outdir=path\to\output\directory"

        <ffmpeg>    Full path to ffmpeg.exe

                    Default:
                    %ProgramFiles%\ffmpeg\bin\ffmpeg.exe

                    Example:
                    set "ffmpeg=path\to\ffmpeg.exe"

        <ffprobe>   Full path to ffprobe.exe

                    Default:
                    %ProgramFiles%\ffmpeg\bin\ffprobe.exe

                    Example:
                    set "ffprobe=path\to\ffprobe.exe"

Licence
-------

    Copyright (c) 2015-2016 Ron MacNeil

    Permission to use, copy, modify, and/or distribute this software for any
    purpose with or without fee is hereby granted, provided that the above
    copyright notice and this permission notice appear in all copies.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
    IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
