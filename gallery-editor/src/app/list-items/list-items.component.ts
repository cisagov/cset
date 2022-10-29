import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
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
  @Input()
  listTest!: ListTest;
  @Input() isRoot: boolean = false;
  faArrows = faArrows;

  response: any;
  responseAdd: any;

  options: Options = {    
    handle: '.handle'
  };

  constructor(private svcGalleryEditor: GalleryEditorService ){   
    
    this.options = {
      group: 'test',
      onUpdate: (event: any) => {
        console.log('updated');
        //if event.from.id and event.to.id are empty then we are moving a whole group
        //changing the index of the rows
        //if event.from.id and event.to.id are the same we are moving within a group
        //if event.from.id and event.to.id are different we are moving from one group to another

        // console.log(event.from.id);
        // console.log(event.to.id);        
        console.log(event.oldIndex +":"+ event.newIndex)
        let item = new MoveItem();
        item.fromId = event.from.id;
        item.toId = event.to.id;
        item.newIndex = event.newIndex;
        item.oldIndex = event.oldIndex;
        item.Layout_Name = event.Layout_Name;

        this.svcGalleryEditor.updatePositionOfItem(item).subscribe();
      },
      onAdd: (event: any) => {
        console.log('added');         
        console.log(event.oldIndex +":"+ event.newIndex)
      },
      onRemove: (event: any) => {        
        console.log('removed');                
        console.log(event.oldIndex +":"+ event.newIndex)
      },
    };
  }

  ngOnInit(): void {    
  }
  
  open(item:any, value:string){
    console.log(item);
    if(item.group_Id!==undefined)
      this.svcGalleryEditor.UpdateGalleryGroupName(item.group_Id, value).subscribe();
    if(item.gallery_Item_Id!==undefined)
      this.svcGalleryEditor.UpdateGalleryItem(item.gallery_Item_Id, value).subscribe();
  }

 

  deleteGalleryItem(id: any) {
    console.log(id + " would be deleted");
    // this.svcGalleryEditor.deleteGalleryItem(id).subscribe(
    //   (r: any) => {
    //     // this.response = r;
    //     console.log(this.response);
    //     this.updateItems();
    //   },
    //   error => console.log('Gallery Item delete error ' + (<Error>error).message)
    // );
  }

  deleteGalleryGroup(item:any) {
    console.log(item.group_Id);
    // this.svcGalleryEditor.deleteGalleryGroup(id).subscribe(
    //   (r: any) => {
    //     this.updateItems();

    //   },
    //   error => console.log('Gallery Group delete error ' + (<Error>error).message)
    // );
  }

  addGalleryGroup(group: string, description: string, title: string) {
    let firstColumnId = 0;
    this.svcGalleryEditor.addGalleryGroup(group,description, title, firstColumnId).subscribe(
      (r: any) => {
        //this.responseAdd = r;
        //console.log(this.responseAdd);
        this.updateItems();

        
      },
      error => console.log('Gallery add item error ' + (<Error>error).message)
    );
  }

  addGalleryItem(description: string, title: string, group: string) {
    let columnId = 0;
    for (let i = 0; i < this.response?.rows?.length; i++) {
      if (this.response?.rows[i]?.group_Title === group) {
        columnId = this.response?.rows[i]?.galleryItems?.length; //becomes one more than the last columnId
        break;
      }
    }

    this.svcGalleryEditor.addGalleryItem(description, title, group, columnId).subscribe(
      (r: any) => {
        this.responseAdd = r;
        this.updateItems();
      },
      error => console.log('Gallery add item error ' + (<Error>error).message)
    );
  }

  cloneGalleryItem(item: any) {
    
    this.svcGalleryEditor.cloneGalleryItem(item).subscribe(
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
    this.svcGalleryEditor.getGalleryItems().subscribe(
      (r: any) => {
        this.response = r;
        console.log(this.response);
      },
      error => console.log('Gallery Layout error ' + (<Error>error).message)
    );
  }


}
