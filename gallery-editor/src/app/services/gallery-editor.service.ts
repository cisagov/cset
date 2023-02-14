import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { GalleryItem, ListTest, MoveItem, UpdateItem } from '../list-items/listtest.model';

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
  unusedItemList: ListTest[]= [];
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
    moveItem.Layout_Name = this.layoutName;
    return  this.http.post("http://localhost:5000/api/galleryEdit/updatePosition",  moveItem,headers);
  }
  updateGalleryGroupName(group_Id: any, value: string) {
    let newUpdateItem = new UpdateItem();
    newUpdateItem.Group_Id = group_Id;
    newUpdateItem.IsGroup = true;
    newUpdateItem.Value = value;
    return  this.http.post("http://localhost:5000/api/galleryEdit/updateName", newUpdateItem, headers);
  }
  updateGalleryItemName(item_Id: any, value: string) {
    let newUpdateItem = new UpdateItem();
    newUpdateItem.Group_Id = item_Id;
    newUpdateItem.IsGroup = false;
    newUpdateItem.Value = value;
    return  this.http.post("http://localhost:5000/api/galleryEdit/updateName", newUpdateItem, headers);
  }
  updateGalleryItem(Gallery_Item_Id: number, Icon_File_Name_Small: string, Icon_File_Name_Large: string, Configuration_Setup: string, Description: string, Title: string, Is_Visible: boolean) {
    let newUpdateItem = new GalleryItem();
    newUpdateItem.gallery_Item_Id = Gallery_Item_Id;
    newUpdateItem.icon_File_Name_Small = Icon_File_Name_Small;
    newUpdateItem.icon_File_Name_Large = Icon_File_Name_Large;
    newUpdateItem.configuration_Setup = Configuration_Setup;
    newUpdateItem.description = Description;
    newUpdateItem.configuration_Setup_Client = undefined;
    newUpdateItem.title = Title;
    newUpdateItem.is_Visible = Is_Visible;
   
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

  getGalleryLayouts() {
    return  this.http.get("http://localhost:5000/api/gallery/getlayouts");
  }

  cloneGalleryItem(item: any, newId: boolean) {
    return  this.http.get("http://localhost:5000/api/gallery/cloneItem",  {
      params: {
        Item_To_Clone: item.gallery_Item_Id,
        Group_Id: item.parent_Id,
        New_Id: newId    
      }
    });
  }

  cloneGalleryGroup(group: any) {
    console.log(group);
    return  this.http.get("http://localhost:5000/api/gallery/cloneGroup",  {
      params: {
        Group_Id: group.group_Id, 
        layout_Name: this.layoutName
      }
    });
  }

  addGalleryItem(description: string, title: string, iconSmall: string, iconLarge: string, configSetup: string, parent_Id:number, columnId: number) {    
    return  this.http.get("http://localhost:5000/api/gallery/addItem",  {
      params: {
        newDescription: description,
        newTitle: title,
        newIconSmall: iconSmall,
        newIconLarge: iconLarge,
        newConfigSetup: configSetup,
        group_Id: parent_Id,
        columnId: columnId
      }
    });
  }

  addGalleryGroup(group: string, description: string, title: string, iconSmall: string, iconLarge: string, configSetup: string, columnId: number) {
    return this.http.get("http://localhost:5000/api/gallery/addGroup",  {
      params: {
        group: group,
        layout: this.layoutName,
        newDescription: description,
        newTitle: title,
        newIconSmall: iconSmall,
        newIconLarge: iconLarge,
        newConfigSetup: configSetup,
        columnId: columnId
      }
    });
  }

  deleteGalleryItem(item: any) {
    return  this.http.get("http://localhost:5000/api/gallery/deleteGalleryItem",  {
      params: {
        id: item.gallery_Item_Id,
        group_id: item.parent_Id
      }
    });
  }

  deleteGalleryGroup(item: any) {
    return  this.http.get("http://localhost:5000/api/gallery/deleteGalleryGroup",  {
      params: {
        id: item.group_Id,
        layout: this.layoutName
      }
    });
  }

  setUnusedItems(unusedList: ListTest[]) {
    this.unusedItemList = unusedList;
  }
  getGalleryUnsedItems() {
    return  this.http.get("http://localhost:5000/api/gallery/getUnused",  {
      params: {
        Layout_Name: this.layoutName
      }
    });
  }
}


