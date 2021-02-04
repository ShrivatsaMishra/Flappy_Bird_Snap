//Flappy Code
    import processing.sound.*;
    import processing.serial.*;
    Serial myPort;
    SoundFile Flap;
    SoundFile GO;
    String Sval="0";
    float Bval=0;
    float Gval=0;
    boolean GMove=true;
    boolean GmO=false;
    int x;
    bird b = new bird();
    pillar[] p = new pillar[3];
    Bullet B = new Bullet(0);
    gun G=new gun();
    boolean end=false;
    boolean intro=true;
    int score=0;
    int HighScore=0;
    int Dis=2300;
    int m=0;
    int n=0;
    int k=0;
    int day=1;
    
    void setup()
    {
      String portName = Serial.list()[0];
      myPort = new Serial(this, portName, 9600);
      size(500,800);
      for(int i = 0;i<3;i++)
      {
        p[i]=new pillar(i);
      }
      Flap=new SoundFile(this,"Flap.mp3");
      GO=new SoundFile(this,"Game Over.mp3");
      Flap.amp(0.02);
    }
    void draw()
    {
      if(myPort.available()>0) 
      {  
        Sval=myPort.readStringUntil('\n');
      }
      if(Sval!=null)
      {  
        x=Sval.indexOf("&");
        Bval=float(Sval.substring(0,1));
        Gval=float(Sval.substring(x+1));        
      }
      if(Bval<1||Bval>2)
      {
        b.jump(); 
        intro=false;
        if(end==false)
        {
          reset();
        }
      }
      if(Gval<2000)
        GMove=!GMove;
      if((score/20)%10==0)
      {
        background(41,227,255);
        fill(37,255,21);
        rect(0,700,500,100);
        cloud((m)%500,100+(n));
        cloud((20+m)%500,270+(n));
        cloud((m)%500,500+(n));
        cloud((250+m)%500,100+(n));
        cloud((250+m)%500,500+(n));
        cloud((270+m)%500,300+(n));
        Tree((100+m)%500,50);
        Tree((250+m)%500,0);
        Tree((400+m)%500,-30);
        m+=1;
        if(m%5==0)
        {
          G.New_Bullet();
          if(k==0)
            n+=1;
          if(n==15)
            k=1;
          if(k==1)
            n-=1;
          if(n==0)
            k=0;
        }
      }
      else
      {
        day=0;
        background(0);
        fill(255);
        ellipse(0,0,100,100);
      }
      if(GMove)
        G.drag();
      if(G.Pos>800)
        G.Pos=0;
      if(G.Pos<-1)
        G.Pos=800;
      G.drawGun();
      stroke(0);
      if(end)
      {
        b.move();
      }
      b.drawBird();
      if(end)
      {
        b.drag();
      }
      b.checkCollisions();
      for(int i = 0;i<3;i++)
      {
        p[i].drawPillar();
        p[i].checkPosition();
      }
      B.DrawBullet();
      B.checkPosition();
      fill(0);
      stroke(0);
      textSize(32);
      if(end)
      {
        rect(20,20,100,50);
        rect(20,120,100,50);
        fill(255);
        text(score,30,58);
        text(HighScore,30,158);
      }
      else
      {
        rect(150,100,200,50);
        rect(150,200,200,50);
        fill(255);
        if(intro)
        {
          text("Flappy Code",155,140);
          text("Click To Play",150,240);
        }
        else
        {
          if(score>HighScore)
          {
            HighScore=score;
          }
          if(GmO==true)
          {
            GO.play();
            GmO=false;
          }
          fill(0);
          rect(120,300,270,50);
          fill(255);
          text("Game Over",170,140);
          text("Score",180,240);
          text(score,280,240);
          text("High Score",140,340);
          text(HighScore,350,340);
        }
      }
    }
    class Bullet
    {
      int x,y;
      boolean cashed;
      Bullet(int y0)
      {
        x=500;
        y=y0;
        cashed=false;
      }
      void DrawBullet()
      {
        if(day==1)
        {
          fill(0);
          stroke(0);
        }
        else
        {
          fill(255);
          stroke(255);
        }
        rect(x,y-10,40,20);
        ellipse(x-5,y,20,20); 
      }
      void Assign(int Y)
      {
        y=Y;
      }
      int RY()
      {
        return y;
      }
      void move()
      {
        x+=1;
      }
      void checkPosition()
      {
        if(x<0)
        {
          x=500;
          cashed=false;
        } 
        if(x<250 && cashed==false)
        {
          cashed=true;
        }
      }
    }
    class gun
    {
      int Pos,n;
      gun()
      {
        Pos=0;
        n=0;
      }
      void drag(){
        Pos-=2; 
      }
      void drawGun()
      {
        if(day==1)
          fill(0);
        else
          fill(255);
        rect(450,Pos-10,50,20);
        rect(450,Pos-20,10,40);
      }
      void New_Bullet()
      {
          Bullet a =new Bullet(Pos);
          B.Assign(a.RY());
      }
    }
    class bird{
      float xPos,yPos,ySpeed;
      bird()
      {
        xPos = 250;
        yPos = 400;
      }
      void drawBird()
      {
        fill(255,0,0);
        ellipse(xPos+10,yPos+3,15,10);
        fill(255,255,0);
        strokeWeight(2);
        ellipse(xPos,yPos,20,20);
        fill(255);
        ellipse(xPos+5,yPos-5,10,10);
        fill(0);
        ellipse(xPos+7,yPos-5,5,5);
        fill(255,255,149);
        ellipse(xPos-10,yPos+5,15,12);
      }
      void jump()
      {
        Flap.play();
        ySpeed=-5; 
      }
      void drag()
      {
        ySpeed+=0.4; 
      }
      void move(){
        yPos+=ySpeed; 
        for(int i = 0;i<3;i++)
        {
          p[i].xPos-=(2+(score/15));
        }
        B.x-=2;
      }
      void checkCollisions()
      {
        if(yPos>800)
        {
          end=false;
        }
        for(int i = 0;i<3;i++)
        {
          if((xPos<p[i].xPos+10 && xPos>p[i].xPos-10) && (yPos<p[i].opening-100 || yPos>p[i].opening+100))
          {
            end=false; 
          }
        }
        if((xPos<B.x+40 && xPos>B.x-10) && (yPos<B.y+20 && yPos>B.y-10))
        {
          end=false;
        }
        if(!end)
        {  
          GO.play();
        }
        if(end==true)
          GmO=true;
      } 
    }
    class pillar
    {
      float xPos, opening;
      boolean cashed = false;
      pillar(int i)
      {
        xPos = 100+(i*200);
        opening = random(600)+100;
      }
      void drawPillar()
      {
        if((score%20)<10)
          fill(18,230,39);
        else
          fill(255,0,0);
        rect(xPos,0,4,opening-100);
        rect(xPos+4,0,4,opening-100);
        rect(xPos+8,0,4,opening-100);
        rect(xPos+12,0,4,opening-100);
        rect(xPos,opening+100,4,700-opening);
        rect(xPos+4,opening+100,4,700-opening);
        rect(xPos+8,opening+100,4,700-opening);
        rect(xPos+12,opening+100,4,700-opening);
      }
      void checkPosition()
      {
        if(xPos<0)
        {
          xPos+=(200*3);
          opening = random(600)+100;
          cashed=false;
        } 
        if(xPos<250&&cashed==false)
        {
          cashed=true;
          score++; 
        }
      }
    }
    void reset()
    {
      end=true;
      score=0;
      b.yPos=400;
      for(int i = 0;i<3;i++)
      {
        p[i].xPos+=550;
        p[i].cashed = false;
      }
      B.x=0;
    }
    void mousePressed()
    {
      b.jump();
      intro=false;
      if(end==false)
      {
        reset();
      }
    }
    void keyPressed()
    {
      b.jump(); 
      intro=false;
      if(end==false)
      {
        reset();
      }
    }
    void cloud(int x,int y)
    {
      fill(255);
      stroke(255);
      ellipse(x,y,100,50);
      ellipse(x-50,y,50,50);
      ellipse(x+50,y,50,50);
    }
    void Tree(int x,int y)
    {
      fill(152,76,0);
      stroke(152,76,0);
      rect(x-10,650-y,20,110);
      fill(0,204,0);
      stroke(0,204,0);
      ellipse(x,630-y,80,80);
      ellipse(x+40,630-y,60,60);
      ellipse(x-40,630-y,60,60);
      ellipse(x,590-y,60,60);
    }
