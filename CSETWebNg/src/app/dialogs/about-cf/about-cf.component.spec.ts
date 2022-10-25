import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AboutCfComponent } from './about-cf.component';

describe('AboutCfComponent', () => {
  let component: AboutCfComponent;
  let fixture: ComponentFixture<AboutCfComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AboutCfComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AboutCfComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
