import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';

import { NetworkWarningsComponent } from './network-warnings.component';

describe('NetworkWarningsComponent', () => {
  let component: NetworkWarningsComponent;
  let fixture: ComponentFixture<NetworkWarningsComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ NetworkWarningsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(NetworkWarningsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
