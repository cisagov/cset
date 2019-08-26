//given a list of network warning nodes add them to the diagram graph
//
class CsetAnalysisWarnings{
    constructor(){}
    addWarningsToDiagram(warnings, graph){
        this.warnings = warnings;
        this.graph = graph;
        //for each warning 
        //create a node in the diagram 
        var sum = 0;
        var numbers = [65, 44, 12, 4];
        var model = this.graph.model;
        model.beginUpdate();
        try
        {
            numbers.forEach(insertWarningCell);
        }
        finally
        {
            model.endUpdate();
        }
    }
   
    
    insertWarningCell(item) {        

        this.graph.insertVertex(item.parent, item.id, item.number, item.x, item.y, item.height, item.width, item.style);        
    }

}
