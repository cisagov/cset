export class ListTest {
    title?:string;
    group_title?:string;
    children?: ListTest[] =[];
    gallery_Item_Guid?: string;
    group_Detail_Id?: number;
    group_Id?:number;    
    isUnused?: boolean = false;
    icon_File_Name_Small?: string;
    icon_File_Name_Large?: string;
    configuration_Setup?: string;
    configuration_Setup_Client?: string;
    description?: string;
    is_Visible?: boolean;
}

export class GalleryItem {
    gallery_Item_Guid?: string;
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
    Group_Id?: number;
    Gallery_Item_Guid?: string;
    Value!: string;
}

export class MoveItem{
    fromId!:string;
    toId!:string;
    oldIndex!: string;
    newIndex!: string;
    Layout_Name!: string;
    gallery_Item_Guid?: string;
}