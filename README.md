
Installation
============

    npm install -g lhapp

API
===

Client.constructor(name, token)
-------------------------------

Creates a client instance with ``name`` and ``token`` stored as attributes.
If your company's domain name at lighthouse is i.e. ``foobar.lighthouseapp.com``
then you should pass ``foobar`` as ``name``.


Client.getProfile(callback)
---------------------------

Runs callback with ``user`` object (profile of the token's owner).


Client.getUser(userId, callback)
--------------------------------

Runs callback with ``user`` object for given ``userId``.


Client.getProjects(callback)
----------------------------

Runs callback with ``projects`` list accessible by the client.


Client.getProject(projectId, callback)
--------------------------------------

Runs callback with ``project`` object for given ``projectId``.


Client.getTickets(projectId, callback, limit=30, page=1, query='')
------------------------------------------------------------------

Runs callback with ``tickets`` list for given ``projectId``.


Client.getTicket(projectId, ticketNumber, callback)
---------------------------------------------------

Runs callback with ``ticket`` object for given ``projectId`` and
``ticketNumber``.


Client.getMilestones(projectId, callback)
-----------------------------------------

Runs callback with ``milestones`` list for given ``projectId``.


Client.getMilestone(projectId, milestoneId, callback)
-----------------------------------------------------

Runs callback with ``milestone`` object for given ``projectId`` and
``milestoneId``.


Client.getChangesets(projectId, callback)
-----------------------------------------

Runs callback with ``changesets`` list for given ``projectId``.


Development
===========

We write ``lhapp`` in *coffee-script*. For tests we use *mocha*. In order to
run tests simply type in a terminal:

    ./run_tests.sh

