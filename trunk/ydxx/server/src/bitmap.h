#ifndef  _BITMAP_H_
#define _BITMAP_H_


#include "defines.h"

#define BITMAP_FILE_HEADER_SIZE 14
#define BITMAP_INFO_HEADER_SIZE 40

typedef struct {
	unsigned short m_signature;
	unsigned int m_size;
	unsigned int m_reserved;
	unsigned int m_bit_offset;
}BitmapFileHeader;


typedef struct {
	unsigned int m_header_size;
	int m_width;
	int m_height;
	unsigned short m_planes;
	unsigned short m_bit_count;
	unsigned int m_compression;
	unsigned int m_size_image;
	int m_pels_per_meter_x;
	int m_pels_per_meter_y;
	unsigned int m_clr_used;
	unsigned int m_clr_important;
	unsigned int m_red_mask;
	unsigned int m_green_mask;
	unsigned int m_blue_mask;
	unsigned int m_alpha_mask;
	unsigned int m_cs_type;
	unsigned int m_endpoints[9];
	unsigned int m_gamma_red;
	unsigned int m_gamma_green;
	unsigned int m_gamma_blue;
}BitmapHeader;


uint * load_bitmap(const char *path, int *w, int *h);


#endif
