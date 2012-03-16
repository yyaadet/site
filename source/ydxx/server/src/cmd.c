#include "hf.h"



CmdTrans *cmd_trans_new1()
{
	CmdTrans *cmd = (CmdTrans *) cache_pool_alloc(POOL_CMD_TRANSFER);
	if (!cmd) 
		return NULL;

	memset(cmd, 0, sizeof(CmdTrans));
	
	return cmd;
}

CmdTrans *cmd_trans_new(int from_id, int to_id, int type, int sph_id, \
				int good_type, int good_id, int good_num, int end)
{
	CmdTrans *cmd = (CmdTrans *) cache_pool_alloc(POOL_CMD_TRANSFER);
	if (!cmd) 
		return NULL;

	cmd->id = 0;
	cmd->from_id = from_id;
	cmd->to_id = to_id;
	cmd->type = type;
	cmd->sph_id = sph_id;
	cmd->good_type = good_type;
	cmd->good_id = good_id;
	cmd->good_num = good_num;
	cmd->end = end;
	
	return cmd;
}



void cmd_trans_free(CmdTrans *cmd)
{
	if (!cmd)
		return;
	cache_pool_free(POOL_CMD_TRANSFER, cmd);
}

void do_execute_cmd_transfer(CmdTrans *cmd, bool cancel)
{
	Game *g = GAME;
	Wubao *w = NULL;
	City *c, *c1;
	Gene *gene = NULL;

	c = c1 = NULL;
	if(!cmd) {
		DEBUG(LOG_FMT"cmd is null, return.\n", LOG_PRE);
		return;
	}

	if(cmd->type == TRANS_WU_TO_CI) {
		if(!(w = game_find_wubao(g, cmd->from_id)))
			goto error;
		
		if (!(c = game_find_city(g, cmd->to_id)))
			goto error;

		/*
		if (!(cmd->sph_id == c->sph_id && c->sph_id > 0))
			goto error;
		*/	
		if(cmd->good_type == GOOD_GENE) {
			if ((gene = game_find_gene(g, cmd->good_id))) {
				gene_change_place(gene, GENE_PLACE_CITY, c->id);
				send_nf_gene_where(gene, WHERE_ALL);
			}
		}
	}
	else if (cmd->type == TRANS_CI_TO_CI) {
		if (!(c = game_find_city(g, cmd->from_id)))
			goto error;
		if (!(c1 = game_find_city(g, cmd->to_id)))
			goto error;

		/*
		if (!(c1->sph_id == cmd->sph_id && c1->sph_id > 0))
			goto error;
		*/

		if (cmd->good_type == GOOD_GENE) {
			if ((gene = game_find_gene(g, cmd->good_id))) {
				gene_change_place(gene, GENE_PLACE_CITY, c1->id);
				send_nf_gene_where(gene, WHERE_ALL);
			}
		}
	}
	else if (cmd->type == TRANS_CI_TO_WU) {
		if (!(c = game_find_city(g, cmd->from_id)))
			goto error;
		if (!(w = game_find_wubao(g, cmd->to_id)))
			goto error;

		/*
		if (!(w->sph_id == cmd->sph_id && cmd->sph_id > 0)) 
			goto error;
			*/

		if (cmd->good_type == GOOD_GENE) {
			if ((gene = game_find_gene(g, cmd->good_id))) {
				gene_change_place(gene, GENE_PLACE_WUBAO, w->id);
				send_nf_gene_where(gene, WHERE_ALL);
			}
		}
	}
	else {
		goto error;
	}	
	
	game_del_cmd_trans(g, cmd);
	cmd_trans_free(cmd);

	return;
error:
	if (cmd->good_type == GOOD_GENE) {
		if ((gene = game_find_gene(g, cmd->good_id)) && \
				(w = game_find_wubao_by_uid(g, gene->uid))) {
			gene_change_place(gene, GENE_PLACE_WUBAO, w->id);
			send_nf_gene_where(gene, WHERE_ALL);
		}
	}


	game_del_cmd_trans(g, cmd);
	cmd_trans_free(cmd);
}


