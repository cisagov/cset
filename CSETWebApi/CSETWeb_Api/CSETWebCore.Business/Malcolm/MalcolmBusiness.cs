using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Malcolm;
using CSETWebCore.Model.Malcolm;
using Newtonsoft.Json;
using NPOI.POIFS.Properties;
using NPOI.SS.Formula.Functions;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static CSETWebCore.Business.Malcolm.Graph;

namespace CSETWebCore.Business.Malcolm
{
    public class MalcolmBusiness : IMalcolmBusiness
    {
        private CSETContext _context;

        private Dictionary<string, Node> treeDictionary = new Dictionary<string, Node>();
        private HashSet<string> alreadySeenList = new HashSet<string>();


        public MalcolmBusiness(CSETContext context) 
        {
            _context = context;
        }

        public IEnumerable<MalcolmData> GetMalcolmJsonData()
        {
            string[] files = Directory.GetFiles("C:\\Users\\WINSMR\\Documents\\MalcolmJson");
            var malcolmDataList = new List<MalcolmData>();

            try
            {
                foreach (string file in files)
                {
                    string jsonString = File.ReadAllText(file);
                    var malcolmData = JsonConvert.DeserializeObject<MalcolmData>(jsonString);
                    var dict = new Dictionary<string, int>();
                    var edgeList = new List<Edge>();

                    dict = CreateDictionary(malcolmData.Values.Buckets, dict);
                    //edgeList = GoThroughEdges(malcolmData.Values.Buckets, edgeList, "");
                    Node topLevelNodeHolder = GoThroughEdges(malcolmData.Values.Buckets, "");
                    List<Node> topLevelNodes = topLevelNodeHolder.GetChildren();
                    List<Edge> topLevelEdges = topLevelNodeHolder.GetEdges();

                    treeDictionary.Clear();
                    StartTheTreeWalk(dict, topLevelNodeHolder);
                    //Dictionary<string, Node> minimalSpanningTree_v1 = StartTheTreeWalk(dict, topLevelNodeHolder);

                    // Adjacency list for storing which vertices are connected
                    List<List<int>> adj = new List<List<int>>(dict.Count());

                    for (int i = 0; i < dict.Count(); i++)
                    {
                        adj.Add(new List<int>());
                    }

                    //List<Node> minimalSpanningTree_v2 = 
                    //Graph graph = new Graph(dict.Count, edgeList.Count, edgeList.ToArray());

                    malcolmDataList.Add(malcolmData);
                    
                }

                return malcolmDataList;
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return null;
        }


        public Dictionary<string, int> CreateDictionary (List<Buckets> buckets, Dictionary<string, int> childrenDict)
        {
            foreach (Buckets bucket in buckets)
            {
                if (bucket.Values != null)
                {
                    childrenDict.TryAdd(bucket.Key, bucket.Values.Buckets.Count);
                    childrenDict = CreateDictionary(bucket.Values.Buckets, childrenDict);
                }
                else
                {
                    childrenDict.TryAdd(bucket.Key, 0);
                }
            }

            return childrenDict;
        }


        public Node GoThroughEdges(List<Buckets> buckets, string parentKey)
        {
            // this keeps track of all the nodes going to be read from the bucket list
            Node parentNode = new Node();
            parentNode.key = parentKey;

            // iterating through the buckets
            foreach (Buckets bucket in buckets)
            {
                // setting up the node info for this bucket
                Node currentNode = new Node();
                currentNode.key = bucket.Key;
                currentNode.parentKey = parentKey;

                // establishing the link between this node's parent (passed into this function) and itself
                Edge edge = new Edge();
                edge.src = parentKey;
                edge.dest = bucket.Key;

                currentNode.AddEdge(edge);

                // if this bucket has values (i.e. if this node has children),
                // pass this bucket as the parent and recurse through its values
                Node childrenNodes = new Node();
                if (bucket.Values != null)
                {
                    childrenNodes = GoThroughEdges(bucket.Values.Buckets, bucket.Key);
                }

                currentNode.AddChildren(childrenNodes.GetChildren());
                currentNode.AddEdges(childrenNodes.GetEdges());

                // add this currentNode to the lists of its parent's children and edges
                parentNode.AddChild(currentNode);
                parentNode.AddEdge(edge);
            }

            // return list of children
            return parentNode;
        }


        public void StartTheTreeWalk(Dictionary<string, int> childrenDict, Node topLevelNodeHolder)
        {
            //get the root node
            //var tree = new Dictionary<string, Node>(); //this is the empty tree
            WalkTree(topLevelNodeHolder);
        }


        public void WalkTree(Node node)
        {
            if (alreadySeenList.Contains(node.key))
            {
                return;
            }
            alreadySeenList.Add(node.key);

            var children = node.GetChildren();
            //var organizedChildren = ;
            foreach (var child in children)
            {
                treeDictionary.TryAdd(child.key, child);
                WalkTree(child);

            }

            //treeDictionary.TryAdd(child.key, child);


            //return tree;
        }


        // a modified version of BFS that 
        // stores predecessor of each vertex 
        // in array pred and its distance 
        // from source in array dist
        private static bool BFS(List<List<int>> adj, int src, int dest, int v, int[] pred, int[] dist)
        {
            // a queue to maintain queue of 
            // vertices whose adjacency list 
            // is to be scanned as per normal
            // BFS algorithm using List of int type
            List<int> queue = new List<int>();

            // bool array visited[] which 
            // stores the information whether 
            // ith vertex is reached at least 
            // once in the Breadth first search
            bool[] visited = new bool[v];

            // initially all vertices are 
            // unvisited so v[i] for all i 
            // is false and as no path is 
            // yet constructed dist[i] for 
            // all i set to infinity
            for (int i = 0; i < v; i++)
            {
                visited[i] = false;
                dist[i] = int.MaxValue;
                pred[i] = -1;
            }

            // now source is first to be 
            // visited and distance from 
            // source to itself should be 0
            visited[src] = true;
            dist[src] = 0;
            queue.Add(src);

            // bfs Algorithm
            while (queue.Count != 0)
            {
                int u = queue[0];
                queue.RemoveAt(0);

                for (int i = 0;
                         i < adj[u].Count; i++)
                {
                    if (visited[adj[u][i]] == false)
                    {
                        visited[adj[u][i]] = true;
                        dist[adj[u][i]] = dist[u] + 1;
                        pred[adj[u][i]] = u;
                        queue.Add(adj[u][i]);

                        // stopping condition (when we 
                        // find our destination)
                        if (adj[u][i] == dest)
                            return true;
                    }
                }
            }
            return false;
        }


        public void AddEdgeMinimalSpanningTree(List<List<int>> adj, int src, int dest)
        {
            adj[src].Add(dest);
            adj[dest].Add(src);
        }


        public class Node
        {
            public string key;
            public string parentKey;
            List<Edge> edges = new List<Edge>();
            List<Node> children = new List<Node>();

            public void AddChild(Node node)
            {
                //alreadySeenList.Add(node);
                //fullListOfNodes[node] = true;
                children.Add(node);
            }

            public void AddChildren(List<Node> childrenToAdd)
            {
                children.AddRange(childrenToAdd);
            }

            public void AddEdge(string src,string dest)
            {
                Edge edge = new Edge();
                edge.dest = dest;
                edge.src = src;
                edges.Add(edge);
            }

            public void AddEdge(Edge edge)
            {
                edges.Add(edge);
            }

            public void AddEdges(List<Edge> edgesToAdd)
            {
                edges.AddRange(edgesToAdd);
            }

            public List<Node> GetChildren()
            {
                return children;
            }

            public List<Edge> GetEdges()
            {
                return edges;
            }

        }

        //public Dictionary<string, int> AssignIndexKeyPairs(Dictionary<string, int> childrenDict)
        //{
        //    int i = 0;
        //    var keyIndexPairs = new Dictionary<string, int>();

        //    foreach (string key in childrenDict.Keys)
        //    {
        //        keyIndexPairs.TryAdd(key, i);
        //        i++;
        //    }

        //    return keyIndexPairs;
        //}

        //


    }


    public class Graph
    { 
        public int V, E;
        public Edge[] edge;

        public Graph(int nV, int nE, Edge[] edgeArray)
        {
            V = nV;
            E = nE;
            edge = edgeArray;
        }

        // class to represent edge
        public class Edge
        {
            public string src, dest;
        }

        // class to represent Subset
        class Subset
        {
            public int parent;
            public int rank;
        }

        // A utility function to find
        // set of an element i (uses
        // path compression technique)
        int find(Subset[] subsets, int i)
        {
            if(i > subsets.Length)
            {
                if (subsets[i].parent != i)
                    subsets[i].parent
                        = find(subsets, subsets[i].parent);
                return subsets[i].parent;
            }
            if (subsets[i].parent != i)
                subsets[i].parent
                    = find(subsets, subsets[i].parent);
            return subsets[i].parent;
        }

        // A function that does union
        // of two sets of x and y
        // (uses union by rank)
        Subset[] Union(Subset[] subsets, int x, int y)
        {
            int xroot = find(subsets, x);
            int yroot = find(subsets, y);

            if (xroot > subsets.Length || yroot > subsets.Length)
                subsets[xroot].parent = yroot;

            if (subsets[xroot].rank < subsets[yroot].rank)
                subsets[xroot].parent = yroot;
            else if (subsets[yroot].rank < subsets[xroot].rank)
                subsets[yroot].parent = xroot;
            else
            {
                subsets[xroot].parent = yroot;
                subsets[yroot].rank++;
            }

            return subsets;
        }

        //// The main function to construct MST 
        //// using Kruskal's algorithm 
        //public void KruskalMST()
        //{
        //    // This will store the 
        //    // resultant MST 
        //    Edge[] result = new Edge[V];

        //    // An index variable, used for result[] 
        //    int e = 0;

        //    // An index variable, used for sorted edges 
        //    int i = 0;
        //    for (i = 0; i < V; ++i)
        //        result[i] = new Edge();

        //    // Sort all the edges in non-decreasing 
        //    // order of their weight. If we are not allowed 
        //    // to change the given graph, we can create 
        //    // a copy of array of edges 
        //    Array.Sort(edge);

        //    // Allocate memory for creating V subsets 
        //    Subset[] subsets = new Subset[V];
        //    for (i = 0; i < V; ++i)
        //        subsets[i] = new Subset();

        //    // Create V subsets with single elements 
        //    for (int v = 0; v < V; ++v)
        //    {
        //        subsets[v].parent = v;
        //        subsets[v].rank = 0;
        //    }
        //    i = 0;

        //    // Number of edges to be taken is equal to V-1 
        //    while (e < V - 1)
        //    {
        //        if (e == V - 2)
        //            Console.WriteLine("");
        //        // Pick the smallest edge. And increment 
        //        // the index for next iteration 
        //        Edge next_edge = new Edge();

        //        if (i == edge.Length)
        //            next_edge = edge[i++];

        //        next_edge = edge[i++];

        //        int x = find(subsets, next_edge.src);
        //        int y = find(subsets, next_edge.dest);

        //        // If including this edge doesn't cause cycle, 
        //        // include it in result and increment the index 
        //        // of result for next edge 
        //        if (x != y)
        //        {
        //            result[e++] = next_edge;
        //            Union(subsets, x, y);
        //            //subsets = Union(subsets, x, y);
        //        }
        //    }

        //    // Print the contents of result[] to display 
        //    // the built MST 
        //    Console.WriteLine("Following are the edges in "
        //                      + "the constructed MST");

        //    int minimumCost = 0;
        //    for (i = 0; i < e; ++i)
        //    {
        //        Console.WriteLine(result[i].src + " -- "
        //                          + result[i].dest
        //                          + " == " + result[i].weight);
        //        minimumCost += result[i].weight;
        //    }

        //    Console.WriteLine("Minimum Cost Spanning Tree: "
        //                      + minimumCost);
        //}

        //// The main function to check whether
        //// a given graph contains cycle or not
        //int isCycle(Graph graph)
        //{
        //    int V = graph.V;
        //    int E = graph.E;

        //    Subset[] subsets = new Subset[V];
        //    for (int v = 0; v < V; v++)
        //    {
        //        subsets[v] = new Subset();
        //        subsets[v].parent = v;
        //        subsets[v].rank = 0;
        //    }

        //    for (int e = 0; e < E; e++)
        //    {
        //        int x = find(subsets, graph.edge[e].src);
        //        int y = find(subsets, graph.edge[e].dest);
        //        if (x == y)
        //            return 1;
        //        Union(subsets, x, y);
        //    }
        //    return 0;
        //}
    }
}
