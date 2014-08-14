--Myrial PageRank implementation
Edges = scan(TwitterK2);
Edges = select follower as src, followee as dst from Edges;

--Table of all vertices
Pages = distinct((select src as v
         from Edges)
         +
        (select dst as v
         from Edges));

-- A table with the outdegree for each vertex except for the sink vertices
OutDegree = select src as v, count(*) AS out
            from Edges;
--A table with the out vertices
InDegree = select dst as v from Edges;
Src = diff(Pages, InDegree);
-- A table of vertices that are sinks
-- Schema: Sinks(v:int)
Sources = select v from OutDegree;
Sinks = diff(Pages, Sources);

NumVertices = select count(*) as N from Pages;

-- Schema: PageRank(v:int, rank:float)
PageRank = select v, 1/NumVertices.N as rank from Pages, NumVertices;
--Schema: OldPageRank(v:int, rank:float)
OldPageRank = PageRank;
const tau: 0.15;
const alpha: 1-tau;
const delta: .01;
--Schema: UniformRank(rank:float)
UniformRank = select tau/N as rank from NumVertices;
do
--Schema: IncomingRank (v:int, rank:float) : multiplies the pagerank sum of incoming vertices w/ .85
    IncomingRank = select a.v, alpha*sum(b.rank/c.out) as rank
                   from Pages a, PageRank b, OutDegree c, Edges d where a.v = d.dst and d.src = b.v and c.v = b.v;
--Schema: SinkRank (rank:float) : Sums all SinkRanks, divided evenly among all vertices
    SinkRank = select sum(PageRank.rank) as rank from PageRank, Sinks where PageRank.v = Sinks.v;
--Schema: Pagerank(v:int, rank:float) : Unions the PageRank with the SrcRank eliminating duplicates
    PageRank = (select v, i.rank + u.rank + alpha*s.rank/NumVertices.N as rank
               from IncomingRank i, UniformRank u, SinkRank s, NumVertices)
               +
              (select p.v as v, u.rank + alpha*s.rank/NumVertices.N as rank
              from UniformRank u, Src p, SinkRank s, NumVertices);
--NotConverged(v:int, delta:int) : Computes the difference of the new Pagerank to old Pagerank
    NotConverged = select count(*)!=0 from PageRank, OldPageRank where PageRank.v = OldPageRank.v and abs(PageRank.rank - OldPageRank.rank) >= delta;
--OldPageRank ( v:int, rank:float): sets the old to current pagerank for next iteration
    OldPageRank = PageRank;
while NotConverged;

store(PageRank, PageRankWSink);
