import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { User } from '../models/user.model';

@Injectable({
  providedIn: 'root',
})
export class ContactsService {
    private contactsUpdatedSubject = new BehaviorSubject<User[]>([]);
    public contactsUpdated$ = this.contactsUpdatedSubject.asObservable();


    /**
     * Tell the world that the contacts have been updated
     */
    contactsUpdated(contacts: User[]) {
      this.contactsUpdatedSubject.next(contacts);
    }
}
