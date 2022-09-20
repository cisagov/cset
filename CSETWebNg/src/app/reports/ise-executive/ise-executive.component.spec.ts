import { ComponentFixture, TestBed } from '@angular/core/testing';

import { IseExecutiveComponent } from './ise-executive.component';

describe('IseExecutiveComponent', () => {
  let component: IseExecutiveComponent;
  let fixture: ComponentFixture<IseExecutiveComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ IseExecutiveComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(IseExecutiveComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
