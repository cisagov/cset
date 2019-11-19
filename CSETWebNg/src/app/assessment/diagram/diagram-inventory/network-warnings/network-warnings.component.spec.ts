import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { NetworkWarningsComponent } from './network-warnings.component';

describe('NetworkWarningsComponent', () => {
  let component: NetworkWarningsComponent;
  let fixture: ComponentFixture<NetworkWarningsComponent>;

  beforeEach(async(() => {
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
