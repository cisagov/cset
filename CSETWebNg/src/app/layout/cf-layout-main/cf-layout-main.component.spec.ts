import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CfLayoutMainComponent } from './cf-layout-main.component';

describe('CfLayoutMainComponent', () => {
  let component: CfLayoutMainComponent;
  let fixture: ComponentFixture<CfLayoutMainComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CfLayoutMainComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CfLayoutMainComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
