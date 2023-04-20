import { Component, OnInit } from '@angular/core';
import { ListTest } from './list-items/listtest.model';
import { GalleryEditorService } from './services/gallery-editor.service';
import { FaIconLibrary } from '@fortawesome/angular-fontawesome';
import { faArrows } from '@fortawesome/free-solid-svg-icons';
import { ConfigService } from './services/config.service';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit{
 
  title = 'gallery-editor';  

  list!: ListTest[]; 
  unusedList!: ListTest[]; 
  unusedListCopy: ListTest[] = []; 
  
    response: any;
  layouts: any;

  constructor(public gallerySvc: GalleryEditorService,
    public library: FaIconLibrary,
    public configSvc: ConfigService
    ) {
    library.addIcons(faArrows, faArrows);
  }

  ngOnInit(): void {
    console.log(this.configSvc.config)
    this.gallerySvc.getGalleryLayouts().subscribe(
      (data:any)=>{
        this.layouts = data;

      }
    );
    this.updateItems();  
  }

  
  parentEventHandlerFunction(){
    this.updateItems();
  }

  layoutChange(event: any) {
    this.gallerySvc.setLayout(event.target.value);
    console.log("Layout is: " + this.gallerySvc.getLayout());
    this.updateItems();
    
  }

  updateItems() {
    this.gallerySvc.getGalleryItems().subscribe(  (x: any) => {
        this.list = this.gallerySvc.transformGallery(x.rows);
        this.gallerySvc.setAllItem(this.list);
      },
      error => console.log('Gallery Layout error ' + (<Error>error).message)
    );
    this.gallerySvc.getGalleryUnsedItems().subscribe(  (x: any) => {
      this.unusedList = x;
      this.gallerySvc.setUnusedItems(this.unusedList);   
      this.unusedListCopy = [];  
      this.unusedList.forEach(i=> {i.isUnused=true;this.unusedListCopy.push(i);})
    },
    error => console.log('Gallery Layout error ' + (<Error>error).message)
  );
  }

}
