import { Injectable } from '@angular/core';

/**
 * A service to encapsulate anything specific to the American Water Works Association (AWWA)
 */
@Injectable({
  providedIn: 'root'
})
export class AwwaService {


  /**
   * The callback URL to AWWA's webpage
   */
  url = 'https://awwa.org/cybersecurity';


  /**
   * 
   */
  constructor() { }
}
