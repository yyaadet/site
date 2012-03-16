#include "hf.h"


uint * load_bitmap(const char *path, int *width, int *height)
{
	int fd = -1;
	BitmapFileHeader file_header;
	BitmapHeader info_header;
	uint t = 0;
	int x, y;
	uint *ret = NULL;
	int line_width = 0;
	byte *line = NULL;

	if (!path) {
		return NULL;
	}
	if (-1 == (fd = open(path, O_RDONLY))) {
		ERROR(LOG_FMT"failed to load bitmap '%s': %s\n", LOG_PRE, path, error_string());
		return NULL;
	}

	if (-1 == read(fd, (char *) &file_header, BITMAP_FILE_HEADER_SIZE)) {
		ERROR(LOG_FMT"failed to load bitmap file header.\n", LOG_PRE);
		close(fd);
		return NULL;	
	}


	if (-1 == read(fd, (char *) &info_header, BITMAP_INFO_HEADER_SIZE)) {
		ERROR(LOG_FMT"failed to load bitmap info header.\n", LOG_PRE);
		close(fd);
		return NULL;	
	}

	(*width) = info_header.m_width;	
	(*height) = info_header.m_height;

	line_width = ((info_header.m_width * info_header.m_bit_count / 8) + 3) & ~3;
	if(!(line = (byte *) xmalloc(line_width))) {
		close(fd);
		return NULL;
	}
	
	if (!(ret = (uint *) xmalloc(sizeof(uint) * info_header.m_width * info_header.m_height))) {
		safe_free(line);
		close(fd);
		return NULL;
	}


	DEBUG(LOG_FMT"bitmap width %d, height %d, bit %d, use color %d, compression %d, line width %d\n",
			LOG_PRE, info_header.m_width, info_header.m_height, \
			info_header.m_bit_count, info_header.m_clr_used, info_header.m_compression, line_width);

	for (y = 0; y < info_header.m_height; y++) {
		byte * ptr = 0;

		if (-1 == read(fd, line, line_width)) {
			ERROR(LOG_FMT"failed to load line data.\n", LOG_PRE);
			safe_free(line);
			return false;
		}

		ptr = line;
		
		for (x = 0; x < info_header.m_width; x++) {

			t = *((uint *)ptr);
			
		   	*(ret + x + y * info_header.m_width) = t;

			ptr += 3;

			//DEBUG(LOG_FMT"(%d, %d) = %08x\n", LOG_PRE, x, y, t);
		}
	}
	
	safe_free(line);

	return ret;
}


