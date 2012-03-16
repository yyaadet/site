#include "hf.h"

Zhanyi * zhanyi_new()
{
    return xmalloc(sizeof(Zhanyi));
}

void zhanyi_free(Zhanyi *p)
{
    safe_free(p);
}


Guanka *guanka_new()
{
	return xmalloc(sizeof(Guanka));
}

void guanka_free(Guanka *b)
{
	safe_free(b);
}

Box *box_new()
{
	return xmalloc(sizeof(Box));
}

void box_free(Box *b)
{
	if (!b)
		return;

	free(b);
}


WarGene * war_gene_new()
{
	WarGene *p = NULL;
	int i = 0;

	if (!(p = cache_pool_alloc(POOL_WAR_GENE)))
		return p;

	dstring_clear(&p->name);
	p->id = 0;
	p->gene_id = 0;
	p->kongfu = 0;
	p->intel = 0;
	p->polity = 0;
	p->zhen = 0;
	p->skill = 0;
	p->train = 0;
	p->spirit = 0;
	p->old_sol = 0;
	p->sol = 0;
	p->hurt = 0;
	p->kill = 0;
	p->uid = 0;
	for( i = 0; i < GENE_WEAP_NUM; i++) {
		p->weap[i].id = 0;
		p->weap[i].level = 0;
	}

	return p;
}

void war_gene_free(WarGene *p)
{
	if (!p)
		return;
	cache_pool_free(POOL_WAR_GENE, p);
}

WarRound * war_round_new()
{
	WarRound *p = cache_pool_alloc(POOL_WAR_ROUND);

	if (!p)
		return p;

	memset(p, 0, sizeof(WarRound));
	return p;
}

void war_round_free(WarRound *p)
{
	cache_pool_free(POOL_WAR_ROUND, p);
}

War *war_new()
{
	War *p = cache_pool_alloc(POOL_WAR);

	if (!p)
		return NULL;
	
	p->guan_id = 0;
	p->room_id = 0;

	dstring_clear(&p->name);
	p->gene_num = 0;
	TAILQ_INIT(&p->genes);
	p->dead = 0;
	p->is_win = 0;
	p->gx = 0;
	p->weap_id = 0;
	p->weap_level = 0;
	p->weap_num = 0;
    p->uid = 0;
	
	dstring_clear(&p->target_name);
	p->target_gene_num = 0;
	TAILQ_INIT(&p->target_genes);
	p->dead1 = 0;
    p->target_uid = 0;

	p->round_num = 0;
	TAILQ_INIT(&p->rounds);

	return p;
}

void war_free(War *p)
{
	if(!p)
		return;

	WarGene *e, *t;
	WarRound *r, *r1;

	TAILQ_FOREACH_SAFE(e, &p->genes, link, t) {
		TAILQ_REMOVE(&p->genes, e, link);
		war_gene_free(e);
	}
	
	TAILQ_FOREACH_SAFE(e, &p->target_genes, link, t) {
		TAILQ_REMOVE(&p->target_genes, e, link);
		war_gene_free(e);
	}
	
	TAILQ_FOREACH_SAFE(r, &p->rounds, link, r1) {
		TAILQ_REMOVE(&p->rounds, r, link);
		war_round_free(r);
	}
	cache_pool_free(POOL_WAR, p);
}

WarGene * war_get_gene(War *war, int index)
{
    if (!war)
        return NULL;
    
    int i = 0;
    WarGene *e;
	
    TAILQ_FOREACH(e, &war->genes, link) {
        if (i == index)
            return e;
        i++;
	}

    return NULL;
}

WarGene * war_get_target_gene(War *war, int index)
{
    if (!war)
        return NULL;
    
    int i = 0;
    WarGene *e;
	
    TAILQ_FOREACH(e, &war->target_genes, link) {
        if (i == index)
            return e;
        i++;
	}
    return NULL;
}

int war_get_sol(War *war)
{
    if (!war)
        return 0;
    
    int cnt = 0;
    WarGene *e;
	
    TAILQ_FOREACH(e, &war->genes, link) {
        cnt += e->sol;
	}

    return cnt;
}

int war_get_target_sol(War *war)
{
    if (!war)
        return 0;
    
    int cnt = 0;
    WarGene *e;
	
    TAILQ_FOREACH(e, &war->target_genes, link) {
        cnt += e->sol;
	}

    return cnt;
}

void do_war(War *p)
{
	if (!p)
		return;

	int dead1 = 0;
	int dead2 = 0;
	int hurt1 = 0;
	int hurt2 = 0;
	int exp1 = 0;
	int exp2 = 0;
	float spirit1 = 0;
	float spirit2 = 0;
	float train1 = 0;
	float train2 = 0;
	WarGene *gene1, *gene2;
	WarRound *rd = NULL;
	int left1 = 0;
	int left2 = 0;
	int j = 0;
    int fin1 = 0;
    int fin2 = 0;
    int gene_index1 = 0;
    int gene_index2 = 0;
    int fight_num = 0;


	for (j = 0; j < MAX_ROUND; j++) {
        fin1 = 0;
        fin2 = 0;

        if (fight_num > MAX_FIGHT_ROUND)
            break;

        while ((fin1 == 0 || fin2 == 0) && war_get_sol(p) >0 && war_get_target_sol(p) > 0) {
            DEBUG(LOG_FMT"fin1 %d, fin2 %d\n", LOG_PRE, fin1, fin2);
            int t = 0;
            
            if (!((gene1 = war_get_gene(p, gene_index1)) && (gene2 = war_get_target_gene(p, gene_index2))))
                break;

            while (gene1->sol > 0 && gene2->sol > 0 &&  t < MAX_GENE_ROUND) {

                if (!lua_get_war_army2(gene1, gene2, \
                            &dead1, &hurt1, &exp1, &spirit1, &train1,\
                            &dead2, &hurt2, &exp2, &spirit2, &train2)) {
                    continue;
                }

                safe_sub(gene1->sol, dead1);
                safe_add(gene1->hurt, hurt1);
                safe_add(gene1->kill, dead2);
                safe_add(p->dead, dead1);
                safe_add(gene1->spirit, spirit1);
                CHANGE_TRAIN(gene1->train, train1);

                safe_sub(gene2->sol, dead2);
                safe_add(gene2->hurt, hurt2);
                safe_add(gene2->kill, dead1);
                safe_add(p->dead1, dead2);
                safe_add(gene2->spirit, spirit2);
                CHANGE_TRAIN(gene2->train, train2);

                if (!(rd = war_round_new())) 
                    return;

                rd->id = gene1->id;
                rd->gene_id = gene1->gene_id;
                rd->dead = dead1;
                rd->skill = exp1;
                rd->spirit = spirit1;
                rd->train = train1;

                rd->id1 = gene2->id;
                rd->gene_id1 = gene2->gene_id;
                rd->dead1 = dead2;
                rd->skill1 = exp2;
                rd->spirit1 = spirit2;
                rd->train1 = train2;

                TAILQ_INSERT_TAIL(&p->rounds, rd, link);
                p->round_num++;

                t++;
            }

            t = 0;
            while (((gene1 = war_get_gene(p, gene_index1)) && gene1->sol <= 0 && t < p->gene_num) || t == 0) {
                gene_index1++;
                t++;
                if (gene_index1 == p->gene_num) {
                    gene_index1 = 0;
                    fin1 = 1;
                }
            }
            
            t = 0;
            while (((gene2 = war_get_target_gene(p, gene_index2)) && gene2->sol <= 0 && t < p->target_gene_num) || t == 0) {
                gene_index2++;
                t++;
                if (gene_index2 == p->target_gene_num) {
                    gene_index2 = 0;
                    fin2 = 1;
                }
            }

            if(++fight_num > MAX_FIGHT_ROUND) 
                break;
        }

	}

	/*
	 * who is win ?
	 */

    left1 = war_get_sol(p);
    left2 = war_get_target_sol(p);

	if (left2 > 0) 
		p->is_win = 0;
	else if (left1 <= 0 && left2 <= 0) 
		p->is_win = 0;
	else 
		p->is_win = 1;
}

