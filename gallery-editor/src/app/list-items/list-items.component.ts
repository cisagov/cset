import { Component, OnInit, Input, Output, EventEmitter, NgModule } from '@angular/core';
import { Options } from 'sortablejs';
import { GalleryItem, ListTest, MoveItem } from './listtest.model'
import { faArrows } from '@fortawesome/free-solid-svg-icons';
import { GalleryEditorService } from '../services/gallery-editor.service';
import { isNgTemplate } from '@angular/compiler';

@Component({
  selector: 'app-list-items',
  templateUrl: './list-items.component.html',
  styleUrls: ['./list-items.component.css']
})

export class ListItemsComponent implements OnInit {
  @Input() listTest!: ListTest;
  @Input() unusedList: ListTest[];
  @Input() isRoot: boolean = false;  
  @Output() treeNeedsRefreshed: EventEmitter<string> = new EventEmitter<string>();
  faArrows = faArrows;

  response: any;
  responseAdd: any;

  options: Options = {    
    handle: '.handle'
  };
  showNewItemFields:boolean = false;
  expandOptions: boolean = false;
  changeVisibility: boolean = false;

  constructor(private svcGalleryEditor: GalleryEditorService ){   
    this.unusedList = [];
    this.options = {
      group: 'test',
      onUpdate: (event: any) => {
        console.log(event)

        console.log('updated');
        let v = this.listTest.children;
        let tIsUnused = v?v[0].isUnused:false;
        if(event.from.id == '' && event.to.id == '' && tIsUnused){
          return;
        }
        let item = new MoveItem();
        if(tIsUnused)
        {
          //I'm moving it into a group and need to know 
          //what group is my destination          
          console.log(event);
          console.log(event.oldIndex +":"+ event.newIndex);
          item.fromId = event.from.id;
          item.toId = event.to.id;
          item.newIndex = event.newIndex;
          item.oldIndex = event.oldIndex;
          item.Layout_Name = event.Layout_Name;
        }
        else{        
          console.log(event.oldIndex +":"+ event.newIndex)          
          item.fromId = event.from.id;
          item.toId = event.to.id;
          item.newIndex = event.newIndex;
          item.oldIndex = event.oldIndex;
          item.Layout_Name = event.Layout_Name;
        }
        this.svcGalleryEditor.updatePositionOfItem(item).subscribe();
      },
      onAdd: (event: any) => {
        console.log('added');    
        console.log(event);
        console.log("ids "+ event.from.id +":"+ event.to.id)
        console.log(event.oldIndex +":"+ event.newIndex)
        let item = new MoveItem();
        item.fromId = event.from.id;
        item.toId = event.to.id;
        item.newIndex = event.newIndex;
        item.oldIndex = event.oldIndex;
        item.Layout_Name = event.Layout_Name;
        
        let v = this.unusedList[event.oldIndex];
        
        item.gallery_Item_Guid = v.gallery_Item_Guid;
        this.svcGalleryEditor.updatePositionOfItem(item).subscribe();
      },
      onRemove: (event: any) => {        
        console.log('removed');                
        console.log(event.oldIndex +":"+ event.newIndex)
      },
    };
  }

  ngOnInit(): void {        
  }
  

  parentEventHandlerFunction(){
    this.treeNeedsRefreshed.emit();
  }

  toggleItem(){
    this.showNewItemFields = !this.showNewItemFields;
  }

  updateGalleryGroupName(updateItem: any, value: string) {
    this.svcGalleryEditor.updateGalleryGroupName(updateItem.group_Id, value).subscribe();
  }
  
  updateGalleryItem (guid: string, iconSmall: string, iconLarge: string, configSetup: string, description: string, title: string, visible?: boolean) {
    if(visible == undefined) {
      visible = false;
    }
    this.svcGalleryEditor.updateGalleryItem(guid, iconSmall, iconLarge, configSetup, description, title, visible).subscribe();
  }
  
  
  open(item:any, value:string){
    console.log(item);
    if(item.group_Id!==undefined){
      this.svcGalleryEditor.updateGalleryGroupName(item.group_Id, value).subscribe();      
    }
    if(item.gallery_Item_Guid!==undefined){
      this.svcGalleryEditor.updateGalleryItemName(item.gallery_Item_Guid, value).subscribe();      
    }
  }

 

  deleteGalleryItem(item: any) {
    console.log("deleting item");
    console.log(item);
    this.svcGalleryEditor.deleteGalleryItem(item).subscribe(
      (r: any) => {
        // this.response = r;
        console.log(this.response);
        this.updateItems();
      },
      error => console.log('Gallery Item delete error ' + (<Error>error).message)
    );
  }

  deleteGalleryGroup(item:any) {
    console.log(item);
    this.svcGalleryEditor.deleteGalleryGroup(item).subscribe(
      (r: any) => {
        this.updateItems();

      },
      error => console.log('Gallery Group delete error ' + (<Error>error).message)
    );
  }

  addGalleryGroup(group: string, description: string, title: string, iconSmall: string, iconLarge: string, configSetup: string) {
    let firstColumnId = 0;
    this.svcGalleryEditor.addGalleryGroup(group,description, title, iconSmall, iconLarge, configSetup, firstColumnId).subscribe(
      (r: any) => {
        this.responseAdd = r;
        //console.log(this.responseAdd);
        this.updateItems();

        
      },
      error => console.log('Gallery add item error ' + (<Error>error).message)
    );
  }

  addGalleryItem(description: string, title: string, iconSmall: string, iconLarge: string, configSetup: string, item: any) {
    let columnId = 0;
    let tmpItemsList = this.svcGalleryEditor.allItems();
    for (let i = 0; i < tmpItemsList.length; i++) {
      if (tmpItemsList[i]?.group_Id === item.parent_Id) {
        columnId = tmpItemsList[i]?.children?.length??0; //becomes one more than the last columnId
        break;
      }
    }
    console.log(item);
    this.svcGalleryEditor.addGalleryItem(description, title, iconSmall, iconLarge, configSetup, item.parent_Id, columnId).subscribe(
      (r: any) => {
        this.responseAdd = r;
        this.updateItems();
      },
      error => console.log('Gallery add item error ' + (<Error>error).message)
    );
  }

  cloneGalleryItem(item: any, newId: boolean) {
    
    this.svcGalleryEditor.cloneGalleryItem(item, newId).subscribe(
      (r: any) => {
        this.updateItems();
      },
      error => console.log('Gallery Layout error ' + (<Error>error).message)
    );
  }

  cloneGalleryGroup(group: any) {
    this.svcGalleryEditor.cloneGalleryGroup(group).subscribe(
      (r: any) => {
        this.updateItems();
      },
      error => console.log('Gallery Layout error ' + (<Error>error).message)
    );
  }

  updateItems() {
    console.log("updating the items tree");
    this.treeNeedsRefreshed.emit();
    // this.svcGalleryEditor.getGalleryItems().subscribe(
    //   (r: any) => {
    //     this.listTest = r;
    //     console.log(this.response);
    //   },
    //   error => console.log('Gallery Layout error ' + (<Error>error).message)
    // );
  }

  toggleExpandOptions() {
    this.expandOptions = !this.expandOptions;
  }

  toggleVisibility() {
    this.changeVisibility = !this.changeVisibility;
  }

  visibleCheck(visible?: boolean) {
    if (this.changeVisibility) {
      visible = !visible;
    }
    return visible;
  }


}
