import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DataloginComponent } from './datalogin.component';

describe('DataloginComponent', () => {
  let component: DataloginComponent;
  let fixture: ComponentFixture<DataloginComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DataloginComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DataloginComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
