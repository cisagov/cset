export class ListTest {
    title?:string;
    group_title?:string;
    children?: ListTest[] =[];
    gallery_Item_Id?: number; 
    group_Id?:number;    
    isUnused?: boolean = false;
}

export class GalleryItem {
    gallery_Item_Id?: number;
    icon_File_Name_Small?: string;
    icon_File_Name_Large?: string;
    configuration_Setup?: string;
    configuration_Setup_Client?: string;
    description?: string;
    title?: string;
    creationDate?: Date;
    is_Visible?: boolean;
}

export class UpdateItem{
    IsGroup!: boolean;
    Group_Id!: number;
    Value!: string;
}

export class MoveItem{
    fromId!:string;
    toId!:string;
    oldIndex!: string;
    newIndex!: string;
    Layout_Name!: string;
    gallery_Item_Id?: number;
}