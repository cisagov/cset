import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrResourcesComponent } from './crr-resources.component';

describe('CrrResourcesComponent', () => {
  let component: CrrResourcesComponent;
  let fixture: ComponentFixture<CrrResourcesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrResourcesComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrResourcesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
