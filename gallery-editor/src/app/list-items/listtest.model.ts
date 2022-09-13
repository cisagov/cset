export class ListTest {
    title?:string;
    group_title?:string;
    children?: Array<ListTest>;
    gallery_Item_Id?: number; 
    group_Id?:number;
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
}