const supertest = require('supertest');
const app = require('../src/routes');
const {pool}=require('../src/storage');

describe('', () => {
  afterAll((done) => {
    pool.end();
    done();
  });

  it('Add a cat image without image', async (done) => {
    const response = await supertest(app)
        .post('/cats/1/upload');
    expect(response.status).toEqual(400);
    expect(response.body.output.statusCode).toEqual(400);
    expect(response.body.output.payload.statusCode).toEqual(400);
    expect(response.body.output.payload.error).toEqual('Bad Request');
    expect(response.body.output.payload.message).toEqual('File is required');
    done();
  });

  it('Add a cat image with image', async (done) => {
    const response = await supertest(app)
        .post('/cats/2/upload')
        .attach('file', `${__dirname}/test.png`);
    expect(response.status).toEqual(200);
    expect(response.body.fileUrl).toMatch(new RegExp('\/photos\/image-\\d+\.png'));
    done();
  });

  it('Add a cat image for invalid catId', async (done) => {
    const response = await supertest(app)
        .post('/cats/-1/upload')
        .attach('file', `${__dirname}/test.png`);
    expect(response.status).toEqual(500);
    done();
  });

  it('Get image for invalid catId', async (done) => {
    const response = await supertest(app)
        .get('/cats/-1/photos');
    expect(response.status).toEqual(404);
    expect(response.body.output.payload.error).toEqual('Not Found');
    expect(response.body.output.payload.message).toEqual('Cat or photos not found');
    done();
  });

  it('Get image', async (done) => {
    const response = await supertest(app)
        .get('/cats/2/photos');
    expect(response.status).toEqual(200);
    response.body.images.forEach((element) => {
      expect(element).toMatch(new RegExp('\/photos\/image-\\d+\.png'));
    });
    done();
  });
});
