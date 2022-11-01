import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ListTest, MoveItem, UpdateItem } from '../list-items/listtest.model';

const headers = {
  headers: new HttpHeaders()
      .set('Content-Type', 'application/json'),
  params: new HttpParams()
};



@Injectable()
@Injectable({
  providedIn: 'root'
})
export class GalleryEditorService {
  
  allitems:ListTest[]= [];
  setAllItem(list: ListTest[]) {
    this.allitems = list;
  }
  allItems() {
    return this.allitems;
  }

  layoutName: string = 'CSET';

  getLayout() {
    return this.layoutName;
  }

  setLayout(newLayoutName: string) {
    this.layoutName = newLayoutName;
  }

  updatePositionOfItem(moveItem: MoveItem) {
    return  this.http.post("http://localhost:5000/api/galleryEdit/updatePosition",  moveItem,headers);
  }
  UpdateGalleryGroupName(Group_Id: any, value: string) {
    let newUpdateItem = new UpdateItem();
    newUpdateItem.Group_Id = Group_Id;
    newUpdateItem.IsGroup = true;
    newUpdateItem.Value = value;
    return  this.http.post("http://localhost:5000/api/galleryEdit/updateItem", newUpdateItem, headers);
  }
  UpdateGalleryItem(Group_Id: any, value: string) {
    let newUpdateItem = new UpdateItem();
    newUpdateItem.Group_Id = Group_Id;
    newUpdateItem.IsGroup = false;
    newUpdateItem.Value = value;
    return  this.http.post("http://localhost:5000/api/galleryEdit/updateItem",  newUpdateItem, headers);
  }

  constructor(private http: HttpClient) { }
  
  renameKey ( obj: any, oldKey:string, newKey:string ) {
    obj[newKey] = obj[oldKey];
    delete obj[oldKey];
  }
  
  transformGallery(arr:any[]){
    
    arr.forEach( (obj: any) => {
      return this.renameKey(obj, 'group_Title', 'title');
    } );
    arr.forEach( (obj: any) => {
      return this.renameKey(obj, 'galleryItems', 'children');
    } );
    return arr;
  }
    
  /**
   * Retrieves the list of frameworks.
   */
  getGalleryItems() {
    return  this.http.get("http://localhost:5000/api/gallery/getboard",  {
      params: {
        Layout_Name: this.layoutName
      }
    });
  }

  cloneGalleryItem(item: any) {
    return  this.http.get("http://localhost:5000/api/gallery/cloneItem",  {
      params: {
        Item_To_Clone: item.gallery_Item_Id,
        Group_Id: item.parent_Id        
      }
    });
  }

  cloneGalleryGroup(group: any) {
    return  this.http.get("http://localhost:5000/api/gallery/cloneGroup",  {
      params: {
        Group_To_Clone: group
      }
    });
  }

  addGalleryItem(description: string, title: string, parent_Id:number, columnId: number) {    
    return  this.http.get("http://localhost:5000/api/gallery/addItem",  {
      params: {
        newDescription: description,
        newTitle: title,
        group_Id: parent_Id,
        columnId: columnId
      }
    });
  }

  addGalleryGroup(group: string, description: string, title: string, columnId: number) {
    return this.http.get("http://localhost:5000/api/gallery/addGroup",  {
      params: {
        group: group,
        layout: this.layoutName,
        newDescription: description,
        newTitle: title,
        columnId: columnId
      }
    });
  }

  deleteGalleryItem(id: number) {
    return  this.http.get("http://localhost:5000/api/gallery/deleteGalleryItem",  {
      params: {
        id: id
      }
    });
  }

  deleteGalleryGroup(id: number) {
    return  this.http.get("http://localhost:5000/api/gallery/deleteGalleryGroup",  {
      params: {
        id: id
      }
    });
  }
}


